#include <itensor/all.h>
#include "TLIC.h"
#include <sys/stat.h>
#include <iostream>
#include <string>
#include <vector>
#include <ctime>
#include <math.h>       /* exp */
#include <fstream>	//output file
#include <sstream>	//for ostringstream
#include <iomanip>

using namespace std;
using namespace itensor;

//------------------------------------------------------------------MAIN--------------------------------------------------------------------

int main(int argc , char* argv[]){
	
//get input

int size ;
double hx , hz , J , energy_state , dbeta ;

size = atoi(argv[1]);
hx = atof(argv[2]);
hz = atof(argv[3]);

dbeta = 0.001;

J = 1 ;

energy_state = - J * ( double((size - 1.)/size) + hx );
cerr << hx << endl;
cerr << "energy state : " << energy_state << endl;

auto sites = SpinHalf(size,{"ConserveQNs=",false});

// build hamiltonian and doing exp(-dbeta H )

auto ampoH = AutoMPO(sites);

for(int j = 1 ; j < size ; j++)
{
    ampoH += -4. * J , "Sz" , j , "Sz", j+1;
    ampoH += -2. * J * hx , "Sz" , j ;
    ampoH += -2. * J * hz , "Sz" , j ;
}

ampoH += -2. * J * hx , "Sz" , size ;
ampoH += -2. * J * hz , "Sz" , size ;

auto H = toMPO(ampoH);
auto expH = toExpH( ampoH, dbeta );

// build state at beta=0 (maximally disordered)

auto ampo = AutoMPO(sites);

for(int j = 1 ; j <= size ; j++ ) ampo += "Id", j ;

MPO rho_0 = toMPO(ampo,{"Exact=",true});

// normalization of the inizial density matrix 

rho_0 /= trace(rho_0);

MPO rho_beta = MPO(sites);

double beta = 0;
double energy_beta = 0;

cout << setprecision(13);

energy_beta = trace(rho_0,H)/size;

cout << beta << " " << energy_beta << endl;

do
{   
   
    nmultMPO( rho_0 , prime(expH) , rho_0 ,{"MaxDim",1000,"Cutoff",1E-13}); 
    nmultMPO( prime(expH) , rho_0 , rho_0 ,{"MaxDim",1000,"Cutoff",1E-13}); 

    rho_0 /= trace(rho_0);

    energy_beta = trace(rho_0,H)/size;
    beta += 2*dbeta;
    cout << beta << " " << energy_beta << endl;

} while (energy_beta > energy_state );

measure_generating_function( &rho_0 , sites , size , int(size/2) , 200 , hx , hz);

return 0;
// measuring observable Tr(rho O). 

// MPO operator = MPO(sites);
// int first_site = 1;
// int last_site = 2;

// double observable = 0;

// for( int j = 1 ; j < first_site ; j++ )
// {
//     observable *= rho_0(j) * op(sites,"Id",j);
// }

// for( int j = first_site ; j <= last_site ; j++ )
// {
//     observable *= rho_0(j) * operator(j);
// }

// for( int j = last_site + 1 ; j <= size ; j++ )
// {
//     observable *= rho_0(j)* op(sites,"Id",j);
// }


}