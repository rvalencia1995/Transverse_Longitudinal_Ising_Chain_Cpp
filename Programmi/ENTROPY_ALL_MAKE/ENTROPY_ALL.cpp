#include <itensor/all.h>
#include <iostream>
#include <sstream> // for ostringstream
#include <vector>
#include <string>
#include <iomanip>
#include <complex>
#include "/home/ricval/Documenti/MyLibrary/TLIC.h"

using namespace std;
using namespace itensor;
	
//----------------------------------------------------------------------MAIN-----------------------------------------------------------------

int main(int argc , char* argv[])	{
	
	//input	
	if(argc != 5)
		{
		cout << "Input: " << argv[0] << " <N> <tstep> <nmeas> <LOCALE (0) / CLUSTER (1)>" << endl;
		return -1;
		}
	
	int N, nmeas , localvscluster;
	double ttotal , tstep ;
	double wall_time = 12. * 60. * 60. ; //hours * minutes * seconds (wall time in seconds)
	
	get_data_entropy( argv , &N , &tstep , &nmeas , &localvscluster );
	
	//int numberStep = int( ttotal/tstep + (1E-9*(ttotal/tstep)) );
	
	cout << "Getting the sites_file and psi_file" << endl;
	
	stringstream psi_file , sites_file , out;

	build_file_TEBD( &sites_file , &psi_file , N ); 
	 	
	cout << "The files found are called\n"
		 << "Sites -> " << sites_file.str() << "\n"
		 << "Psi -> " << psi_file.str() << "\n" << endl;
 	
	SpinHalf sites;
	readFromFile(sites_file.str(),sites);
	MPS psi(sites);
		
	int n = 0;
		
	string entropy_file = "EntropyAllPoints.dat";
	ofstream SaveEntropy( entropy_file.c_str() );
	
	do
		{
		out.str("");
		out << psi_file.str() << n;
		if( fileExists( out.str() ) == true)
			{
			readFromFile(out.str(),psi);
			double entropy = entanglement_entropy( &psi , N , 1);
			SaveEntropy << n * nmeas * tstep  << " " << entropy ;
			
			for( int k = 2 ; k < N ; k++ )
				{
				entropy = entanglement_entropy( &psi , N , k);
				SaveEntropy << " " << entropy ;
				}
			SaveEntropy << "\n";
				
			}
		n += nmeas;
		} while( fileExists( out.str() ) == true );
	
	n -= 2*nmeas;
	out.str("");
	out << psi_file.str() << n;
	cout << "Last file opened is " << out.str() << endl;
	
	return 0;
}
