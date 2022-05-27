#include <cstdio>
#include <iostream>
#include <string>
#include "dependencies/include/libpq-fe.h"
using std::cout;
using std::endl;
using std::string;
using std::cin;

/*
Qui ci sono le configurazioni per la connessione, la preparazione delle query
e la stampa delle stesse.
*/

PGconn* connect(const char* host, const char* user, const char* db, const char* pass, const char* port) {
    char conninfo[256];
    sprintf(conninfo, "user=%s password=%s dbname=\'%s\' hostaddr=%s port=%s", user, pass, db, host, port);

    PGconn* conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        std::cerr << "Connessione non riuscita." << endl << PQerrorMessage(conn);
        PQfinish(conn);
        exit(1);
    }

    return conn;
}

PGresult* execute(PGconn* conn, const char* query) {
    PGresult* res = PQexec(conn, query);
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "Qualcosa è andato storto..." << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }

    return res;
}

void printLine(int campi, int* maxChar) {
    for (int j = 0; j < campi; ++j) {
        cout << '+';
        for (int k = 0; k < maxChar[j] + 2; ++k){
            cout << '-';
        }
    }
    cout << "+\n";
}
void printQuery(PGresult* res) {
    // Preparazione dati
    const int tuple = PQntuples(res), campi = PQnfields(res);
    string v[tuple + 1][campi];
    for (int i = 0; i < campi; ++i) {
        string s = PQfname(res, i);
        v[0][i] = s;
    }
    for (int i = 0; i < tuple; ++i){
        for (int j = 0; j < campi; ++j) {
            if (string(PQgetvalue(res, i, j)) == "t" || string(PQgetvalue(res, i, j)) == "f"){
                if (string(PQgetvalue(res, i, j)) == "t"){
                    v[i + 1][j] = "si";
                }
                else{
                    v[i + 1][j] = "no";
                }
            }   
            else{
                v[i + 1][j] = PQgetvalue(res, i, j);
            } 
        }
    }
    int maxChar[campi];
    for (int i = 0; i < campi; ++i){
        maxChar[i] = 0;
    }
    for (int i = 0; i < campi; ++i) {
        for (int j = 0; j < tuple + 1; ++j) {
            int size = v[j][i].size();
            maxChar[i] = size > maxChar[i] ? size : maxChar[i];
        }
    }
    // Stampa effettiva delle tuple
    printLine(campi, maxChar);
    for (int j = 0; j < campi; ++j) {
        cout << "| ";
        cout << v[0][j];
        for (int k = 0; k < maxChar[j] - v[0][j].size() + 1; ++k){
            cout << ' ';
        }
        if (j == campi - 1){
            cout << "|";
        }
    }
    cout << endl;
    printLine(campi, maxChar);
    for (int i = 1; i < tuple + 1; ++i) {
        for (int j = 0; j < campi; ++j) {
            cout << "| ";
            cout << v[i][j];
            for (int k = 0; k < maxChar[j] - v[i][j].size() + 1; ++k){
                cout << ' ';
            }
            if (j == campi - 1){
                cout << "|";
            }
        }
        cout << endl;
    }
    printLine(campi, maxChar);
}

//il codice principale
int main(int argc, char** argv) {
    char PGHost[10]="127.0.0.1";
    char PGUser[20]="postgres";
    char PGDataBase[12]="Pentagramma";
    char PGPort[5]="5432";
    printf("Password per l'utente %s (digitare assicurandosi di non essere visti da nessuno): ",PGUser);
    char PGpassword[50];
    cin >> PGpassword;
    PGconn* conn = connect(PGHost, PGUser, PGDataBase, PGpassword, PGPort);

    const char* query[10] = {
        "SELECT \"Nome\", \"Cognome\" FROM \"Persona\" \
        JOIN \"Studente\" ON \"Persona\".\"CF\"=\"Studente\".\"CF\" \
        JOIN \"Apprendimento\" ON \"Studente\".\"CF\"=\"Apprendimento\".\"CF\" \
        JOIN \"Attivita\" ON \"Apprendimento\".\"CodiceAttivita\"=\"Attivita\".\"CodiceAttivita\" \
        WHERE \"FineAttivita\" IS NULL AND \"Corso\"='Pianoforte';",

        "SELECT \"Nome\", \"Cognome\", \"Telefono\" \
        FROM \"Persona\", \"Associato\" \
        WHERE \"Persona\".\"CF\"=\"Associato\".\"CF\" AND \"Associato\".\"DataIscrizione\">='2019-01-01'",

        "SELECT \"Nome\",\"Cognome\" \
        FROM \"Docente\", \"Persona\" \
        WHERE \"Docente\".\"CF\"=\"Persona\".\"CF\" AND \"Docente\".\"CF\" IN \
        (SELECT \"CF\" FROM \"Esaminatore\" GROUP BY \"CF\")",

        "SELECT \"Corso\" \
        FROM \"Docente\", \"Attivita\" \
        WHERE \"Docente\".\"CF\"=\"Attivita\".\"Docente\" \
        GROUP BY \"Corso\" \
        HAVING COUNT(*)>=2",

        "SELECT \"GenereBrano\", COUNT(*) \
        FROM \"Scaletta\" \
        JOIN \"BranoEseguito\" ON \"Scaletta\".\"NomeEvento\"=\"BranoEseguito\".\"NomeEvento\" \
        JOIN \"Brano\" ON \"BranoEseguito\".\"NomeBrano\"=\"Brano\".\"NomeBrano\" AND \"BranoEseguito\".\"Artista\"=\"Brano\".\"Artista\" \
        WHERE \"GenereBrano\"='Metal' \
        GROUP BY \"GenereBrano\"",

        "SELECT \"Indirizzo\", \"Citta\",\"NumSpettatori\" \
        FROM \"Evento\" \
        JOIN \"Sede\" ON \"Evento\".\"LuogoEvento\"=\"Sede\".\"NomeSede\" \
        WHERE \"NumSpettatori\"=(SELECT MAX(\"NumSpettatori\") FROM \"Evento\")",

        "SELECT \"CF\" \
        FROM \"Docente\" \
        WHERE \"InizioDocenza\">='2010-01-01' AND \"FineDocenza\" IS NULL",

        "SELECT \"NomeEvento\" \
        FROM \"Evento\" \
        WHERE \"TipoEvento\"='N'",

        "SELECT \"LuogoEvento\", COUNT(*) \
        FROM \"Evento\" \
        GROUP BY \"LuogoEvento\"",

        "SELECT \"NomeBrano\", COUNT(*) AS \"NumEsecuzioni\" \
        FROM \"BranoEseguito\" \
        GROUP BY \"NomeBrano\" \
        ORDER BY \"NomeBrano\""
    };

    int selectedQuery=-1;
    while (selectedQuery!=0) {
        cout << endl;
        cout << "1) Trovare i nominativi degli studenti che attualmente frequentano il corso di Pianoforte.\n";
        cout << "2) Fornire le generalità (nome, cognome e numero di telefono) degli associati iscritti dal 2018.\n";
        cout << "3) Selezionare i docenti (con nome e cognome) che sono stati esaminatori almeno una volta.\n";
        cout << "4) Elencare i corsi che siano stati tenuti più di una volta\n";
        cout << "5) Mostrare il numero di scalette in cui sia stato eseguito almeno una volta un brano dal genere \"Metal\".\n";
        cout << "6) Mostrare Indirizzo e Citta della sede con il maggior numero di spettatori in un singolo evento.\n";
        cout << "7) Selezionare i docenti (è sufficiente CF) che insegnano dal 2010.\n";
        cout << "8) Mostrare il nome di tutti gli eventi che NON sono saggi.\n";
        cout << "9) Contare tutte le occorrenze in cui la sede sia stata usata per evento (LuogoEvento).\n";
        cout << "10) Trovare per ogni brano (eseguito da qualunque artista) il numero di esecuzioni. Ordinare il risultato in ordine alfabetico.\n";

        cout << "Query da eseguire (0 per uscire): ";
        cin >> selectedQuery;
        while (selectedQuery < 0 || selectedQuery > 10) {
            cout << "Le query vanno da 1 a 10. Riprovare.\n";
            cout << "Query da eseguire (0 per uscire): ";
            cin >> selectedQuery;
        }

        if(selectedQuery != 0){
            int i = selectedQuery -1;
            printQuery(execute(conn, query[i]));
            system("pause");
        }
    }
    PQfinish(conn);
    return 0;
}
