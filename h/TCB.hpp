#ifndef TCB_HPP
#define TCB_HPP

#include "../lib/hw.h"
#include "Scheduler.hpp"
#include "Riscv.hpp"

// klasa TCB predstavlja apstrakciju niti
class TCB {
public:
    // definisanje korisnickog tipa Body - predstavljace pokazivac na void funkciju koja prima void* parametar
    using Body = void (*)(void*);

    // ova funkcija treba da napravi novu nit koja ce da izvrsava telo funkcije date parametrom body
    // ako se prosledi nullptr, to znaci da treba napraviti nit koja ce da izvrsava main funkciju
    // u tom slucaju, u konstrukciji te niti ne treba je davati scheduleru na raspolaganje, jer bi je to suspendovalo -
    // zelimo da bas ta nit main-a nastavi da se izvrsava
    static TCB* createThread(Body body, void* arg, void* stack, bool cppApi);

    // obezbedjena enkapsulacija - atribut finished je privatan i moze se citati samo kroz getter metod, a menjati preko setter metoda
    bool getFinished() const { return finished; }
    void setFinished(bool value) { finished = value; }

    // ovaj metod vraca vremenski odsecak (kvantum) koji je dodeljen tekucem objektu klase TCB (niti)
    // to je broj perioda tajmera - on govori koliko vremena ce se nit izvrsavati
    uint64 getTimeSlice() const { return timeSlice; }

    // ovaj metod vraca adresu funkcije koju treba da izvrsava tekuca nit
    Body getBody() const { return body; }

    // privatne atribute schedulerPrevThread i schedulerNextThread sam ispravno enkapsulirao jer su oni upravo privatni
    // i mogu se modifikovati samo kroz setter metode, a mogu da se procitaju samo preko getter metoda
    TCB* getPrevThreadScheduler() const { return schedulerPrevThread; }
    void setPrevThreadScheduler(TCB* prev) { schedulerPrevThread = prev; }
    TCB* getNextThreadScheduler() const { return schedulerNextThread; }
    void setNextThreadScheduler(TCB* next) { schedulerNextThread = next; }

    // ova metoda sluzi da promeni kontekst, pri cemu tekucu nit suspenduje
    // tako sto je ne vraca u rasporedjivac cak iako ona nije zavrsena
    static void suspendCurrentThread();

    // ova metoda umece tekucu nit u red uspavanih niti i to sa zadatim brojem perioda tajmera koliko ona treba da spava
    static void insertSleepThread(uint64 time);
    // ova metoda azurira listu uspavanih niti tako sto dekrementira sleepTime prve niti u listi, i kada ta vrednost dostigne nulu,
    // onda se u red spremnih niti vracaju sve niti koje takodje imaju sleepTime nula pocevsi od pocetka liste uspavanih niti
    static void updateSleepThreadList();
    TCB* getPrevSleepThread() const { return sleepPrevThread; }
    void setPrevSleepThread(TCB* prev) { sleepPrevThread = prev; }
    TCB* getNextSleepThread() const { return sleepNextThread; }
    void setNextSleepThread(TCB* next) { sleepNextThread = next; }
    void setSleepTime(uint64 time) { sleepTime = time; }
    uint64 getSleepTime() const { return sleepTime; }

    // ove metode sluze kao pomoc za ulancavanje niti u listu blokiranih niti na semaforu
    TCB* getNextSemaphoreThread() const { return semaphoreNextThread; }
    void setNextSemaphoreThread(TCB* next) { semaphoreNextThread = next; }
    // ove metode sluze za postavljanje i dohvatanje flag-a koji nam govori da li je tekuca nit nasilno odblokirana tako sto je
    // semafor na kojem je ona cekala zatvoren sistemskim pozivom sem_close - u tom slucaju sem_wait treba da vrati gresku
    void setWaitSemaphoreFailed(bool value) { waitSemaphoreFailed = value; }
    bool getWaitSemaphoreFailed() const { return waitSemaphoreFailed; }

    int getThreadId() const { return threadId; }

    // preklapamo operatore new i delete zato sto ce se metodi klase TCB izvrsavati u kernel kodu koji se vec izvrsava u okviru prekidne rutine, a
    // nas sistem nema jezgro sa preotimanjem (preemptive kernel), tj. nije dozvoljeno preotimanje za vreme izvrsavanja kernel koda - zato ne smemo
    // da koristimo globalne operatore new i delete jer ce oni pozvati sistemske pozive mem_alloc i mem_free
    static void* operator new(size_t n);
    static void* operator new[](size_t n);
    static void operator delete(void* ptr);
    static void operator delete[](void* ptr);

    ~TCB() { delete[] stack; }

    // pokazivac na nit koja se trenutno izvrsava se cuva u statickom javnom polju runningThread
    static TCB* runningThread;

private:
    friend class Riscv; // hocemo da iz metoda klase Riscv mozemo da pristupimo privatnim atributima klase TCB

    struct Context {
        uint64 ra;
        uint64 sp;
    };

    static void initializeClassAttributes(TCB* thisPointer, Body body, void* arg, void* stack);

    TCB(Body body, void* arg, void* stack);

    TCB(Body body, void* arg, void* stack, bool cppApi);

    // dispatch sluzi za promenu konteksta, pri cemu tekucu nit stavlja u rasporedjivac ukoliko ona nije zavrsena
    static void dispatch();

    // ovu funkciju prvo treba da izvrsi novokreirana nit
    static void threadWrapper();

    // ova funkcija treba da sacuva vrednosti registara ra i sp tekuce niti (oldThread) u njenu strukturu na koju pokazuje oldContext, i da u registre
    // ra i sp upise vrednosti koje se nalaze u strukturi na koju pokazuje runningContext
    static void contextSwitch(Context *oldContext, Context *runningContext);

    // promenljiva timeSliceCounter broji koliko perioda tajmera se trenutno izvrsava tekuca nit (ona na koju pokazuje pokazivac runningThread)
    // kada timeSliceCounter dodje do vrednosti atributa timeSlice (vremenski odsecak, tj. kvantum koji je dat tekucoj niti, tj. tekucem objektu klase TCB),
    // onda treba uraditi promenu tekuce niti i konteksta
    static uint64 timeSliceCounter;

    // pokazivac na funkciju koju ce tekuci objekat klase TCB (nit) izvrsavati
    Body body;
    // argument funkcije koju ce tekuci objekat klase TCB (nit) izvrsavati
    void* arg;
    // vremenski odsecak (kvantum) koji je dodeljen tekucem objektu klase TCB (niti)
    // to je broj perioda tajmera - on govori koliko vremena ce se nit izvrsavati
    uint64 timeSlice = DEFAULT_TIME_SLICE;
    // pokazivac na pocetak dela memorije od kog se smesta stek tekuceg objekta klase TCB (niti)
    // do ove adrese maksimalno stek moze da poraste, posto stek raste logicki od visih adresa ka nizim;
    // dakle, ova adresa je najniza do koje sme da ode stack pointer (sp)
    uint64* stack;
    // u ovoj strukturi cemo cuvati samo registre ra i sp tekuceg objekta klase TCB (niti), dok cemo ostale registre opste namene cuvati na njenom steku
    Context context {};
    // ovaj atribut govori da li je tekuci objekat klase TCB (nit) zavrsio svoje izvrsavanje
    bool finished;

    // ove pokazivace cemo koristiti za ulancavanje niti u listu spremnih niti kojom ce scheduler da raspolaze
    // ove pokazivace cuvam ovde kao privatne atribute (obezbedjena enkapsulacija) klase TCB, da ne bih dinamicki alocirao
    // memoriju za posebne strukture za ulancavanje niti u listu jer to uzrokuje odredjene rezijske troskove i fragmentaciju memorije
    TCB* schedulerNextThread = nullptr;
    TCB* schedulerPrevThread = nullptr;

    // u ovoj promenljivoj cuvamo koliko jos perioda tajmera tekuca nit treba da bude uspavana;
    // ovaj podatak cemo pamtiti tako sto cemo ulancanu listu uspavanih niti odrzavati uredjenom neopadajuce po preostalom vremenu
    // spavanja, pri cemo mozemo samo za prvi element liste da pamtimo tacan broj perioda tajmera koji govori koliko jos ta nit treba
    // da bude uspavana, dok za naredne elemente mozemo da pamtimo samo relativno preostalo vreme u odnosu na prethodne elemente;
    // na ovaj nacin, azuriranje liste na svaku periodu tajmera (prekid) je jednostavno, samo sleepTime prvog elementa liste se dekrementira
    // pa ukoliko je ta vrednost dosla do 0, onda se u red spremnih niti vracaju sve niti s pocetka ove liste koje imaju sleepTime = 0
    uint64 sleepTime = 0;
    // ovi pokazivaci nam sluze za formiranje ulancane liste uspavanih niti
    static TCB* sleepHead;
    static TCB* sleepTail;
    TCB* sleepNextThread = nullptr;
    TCB* sleepPrevThread = nullptr;

    // ovaj pokazivac ce nam sluziti za uvezivanje u listu blokiranih niti na semaforu
    TCB* semaphoreNextThread = nullptr;
    // ovaj flag nam govori da li je sem_wait pozvan za tekucu nit bezuspesno obavljen - slucaj kada je pozvan sem_close i nasilno
    // se odblokira tekuca nit sa semafora
    bool waitSemaphoreFailed = false;

    static int staticThreadId;
    int threadId;
};

#endif