#include<string>
#include<cstring>
#include<iostream>
#include <cstdio>
#include<stdio.h>





#ifndef SYMBOLINFO_H
#define SYMBOLINFO_H


class SymbolInfo
{
    private:
        std::string sname;
        std::string stype;
    public:
        SymbolInfo *next;

        SymbolInfo(std::string nval, std::string tval);
        virtual ~SymbolInfo();
        std::string Getsname() { return sname; }
        void Setsname(std::string val) { sname = val; }
        std::string Getstype() { return stype; }
        void Setstype(std::string val) { stype = val; }
    protected:
};

#endif // SYMBOLINFO_H




#ifndef SCOPETABLE_H
#define SCOPETABLE_H

class ScopeTable
{
    public:
        int Tabid;
        int bucSize;
        ScopeTable *parentScope;
        SymbolInfo **symPtr;
        ScopeTable(int s, int id);
        virtual ~ScopeTable();
        unsigned long int hashfunc(char *str);
        SymbolInfo * LookUp(std::string sym);
        bool Insert(std::string symname, std::string symtype);
        void print();
        bool Delete(std::string sym);
    protected:
    private:
};

#endif // SCOPETABLE_H




#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H

class SymbolTable
{
    public:
        ScopeTable *current;
        int s_buc;
        int curTabid;

        SymbolTable(int s);
        virtual ~SymbolTable();
        void EnterScope();
        void ExitScope();
        bool Insert(std::string symbolname, std::string symboltype);
        bool Remove(std::string symbolname);
        SymbolInfo *LookUp(std::string symbolname);
        void PrintCurrent();
        void PrintAll();
    protected:
    private:
};

#endif // SYMBOLTABLE_H







using namespace std;

SymbolInfo::SymbolInfo(string nval, string tval)
{
    Setsname(nval);
    Setstype(tval);
    next = 0;
}

SymbolInfo::~SymbolInfo()
{
    //dtor
}






ScopeTable::ScopeTable(int s, int id)
{
    symPtr = new SymbolInfo*[s];
    bucSize = s;
    Tabid = id;
    for(int i = 0; i<s; i++){
        symPtr[i] = 0;
    }
}

ScopeTable::~ScopeTable()
{
    SymbolInfo *temp;
    SymbolInfo *temp2;
    for(int i = 0; i < bucSize; i++){
        temp = symPtr[i];
        while(temp != 0){
            temp2 = temp;
            temp = temp->next;
            delete temp2;
        }
    }
    delete[] symPtr;
}

unsigned long int ScopeTable::hashfunc(char *str)
{
    unsigned long int index = 9199;
    int c;
    int i = 0;
    while(c = str[i]){
        index = index * 33 + c;
        i++;
    }
    return index;
}

SymbolInfo * ScopeTable::LookUp(string sym)
{

    unsigned long int index;
    char *cstr = new char[sym.length() + 1];
    strcpy(cstr, sym.c_str());
    index = hashfunc(cstr);
    index = index % bucSize;
    delete []cstr;
    SymbolInfo *temp;
    temp = symPtr[index];
    if (temp == 0) {
        cout << " Not Found" << endl;
        return 0;
    }
    else{
        int i = 0;
        while(temp != 0){
            if (temp->Getsname() == sym) {
                cout << " Found at ScopeTable# " << Tabid << " at position " << index << "," << i << endl;
                return temp;
            }
            else {
                temp = temp->next;
                i++;
            }
        }
    }
    cout << " Not Found" << endl;
    return 0;
}

bool ScopeTable::Insert(string symname, string symtype){
    SymbolInfo *temp;
    temp = LookUp(symname);
    if(temp == 0){
        SymbolInfo *temp2;
        temp2 = new SymbolInfo(symname,symtype);
        unsigned long int index;
        char *cstr = new char[symname.length() + 1];
        strcpy(cstr, symname.c_str());
        index = hashfunc(cstr);
        index = index % bucSize;
        delete []cstr;
        temp = symPtr[index];
        int i = 0;
        if(temp == 0){
            symPtr[index] = temp2;
            cout << " Inserted in ScopeTable #" << Tabid << " at position " << index << "," << i << endl;
            return true;
        }
        i++;
        while(temp->next != 0){
            temp = temp->next;
            i++;
        }
        temp->next = temp2;
        cout << " Inserted in ScopeTable #" << Tabid << " at position " << index << "," << i << endl;
        return true;
    }
    cout << " < " << symname << "," << symtype << " > already exists in curent scope" << endl;
    return false;
}

void ScopeTable::print(){
    SymbolInfo *temp;
    cout << " ScopeTable# " << Tabid << endl;
    for(int i = 0; i < bucSize; i++){
        temp = symPtr[i];
        cout << " " << i << " -->";
        while(temp != 0){
            cout << " < " << temp->Getsname() << ", " << temp->Getstype() << " > ";
            temp = temp->next;
        }
        cout << endl;
    }
}

bool ScopeTable::Delete(string sym){
    SymbolInfo *temp;
    temp = LookUp(sym);
    if(temp == 0){
        return false;
    }
    unsigned long int index;
    char *cstr = new char[sym.length() + 1];
    strcpy(cstr, sym.c_str());
    index = hashfunc(cstr);
    index = index % bucSize;
    delete []cstr;
    temp = symPtr[index];
    SymbolInfo *par;
    par = 0;
    int i = 0;
    while (temp != 0){
        if (temp->Getsname().compare(sym)){
            par = temp;
            temp = temp->next;
            i++;
        }
        else break;
    }
    if (par == 0){
        symPtr[index] = temp->next;
        delete temp;
        cout << " Deleted entry at " << index << "," << i << " from current ScopeTable" << endl;
        return true;
    }
    par->next = temp->next;
    delete temp;
    cout << " Deleted entry at " << index << "," << i << " from current ScopeTable" << endl;
    return true;
}









SymbolTable::SymbolTable(int s)
{
    curTabid = 1;
    s_buc = s;
    ScopeTable *s1;
    s1 = new ScopeTable(s,curTabid);
    s1->parentScope = 0;
    current = s1;

    //ScopeTable s1(s_buc,curTabid);
    //s1.parentScope = 0;
    //current = &s1;
}

SymbolTable::~SymbolTable()
{
	ScopeTable *temp;
	if(current != 0){
		temp = current;
		current = current->parentScope;
		while(temp != 0){
			delete temp;
			temp = current;
			if(temp != 0) current = current->parentScope;
		}
	}
}

void SymbolTable::EnterScope(){
    curTabid++;
    ScopeTable *s1;
    s1 = new ScopeTable(s_buc,curTabid);
    s1->parentScope = current;
    current = s1;
    //ScopeTable s1(s_buc,curTabid);
    //s1.parentScope = current;
    //current = &s1;
    cout << " New ScopeTable with id " << curTabid << " created" << endl;
}

void SymbolTable::ExitScope(){
    if(curTabid >= 1){
        curTabid--;
        ScopeTable *temp;
        temp = current;
        current = current->parentScope;
        delete temp;
    }
}

bool SymbolTable::Insert(string symbolname, string symboltype){
    bool x;
    x = current->Insert(symbolname, symboltype);
    return x;
}

bool SymbolTable::Remove(string symbolname){
    bool x;
    x = current->Delete(symbolname);
    return x;
}

SymbolInfo * SymbolTable::LookUp(string symbolname){
    ScopeTable *temp;
    temp = current;
    SymbolInfo *found;
    while(temp != 0){
        found = temp->LookUp(symbolname);
        if(found) break;
        temp = temp->parentScope;
    }
    return found;
}

void SymbolTable::PrintCurrent(){
    current->print();
}

void SymbolTable::PrintAll(){
    ScopeTable *temp;
    temp = current;
    while(temp != 0){
        temp->print();
        temp = temp->parentScope;
        cout << endl;
    }
}
