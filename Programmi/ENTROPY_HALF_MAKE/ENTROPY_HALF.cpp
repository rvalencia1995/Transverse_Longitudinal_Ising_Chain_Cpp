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
		cerr << "Input: " << argv[0] << " <N> <tstep> <nmeas> <LOCALE (0) / CLUSTER (1)>" << endl;
		return -1;
		}
	
	int N, nmeas, localvscluster;
	double J  , tstep ;
	
	get_data_entropy( argv , &N, &tstep , &nmeas , &localvscluster );
		
	cout << "Input:\n"
		 << "N : " << N << "\n"
		 << "dt : " << tstep << "\n"
		 << "nmeas : " << nmeas << endl;
	
	cout << "Getting the sites_file and psi_file" << endl;
	
	stringstream psi_file , sites_file , save_file , out;

	build_file_entanglement_entropy( &sites_file , &psi_file , &save_file , N ); 
		 	
	cout << "The files found are called\n"
		 << "Sites -> " << sites_file.str() << "\n"
		 << "Psi -> " << psi_file.str() << "\n" << endl;
 	
	SpinHalf sites;
	readFromFile(sites_file.str(),sites);
	MPS psi(sites);
		
	int n = 0;
	
	vector<double> entEntropy;
	
	do
		{
		out.str("");
		out << psi_file.str() << n;
		if( fileExists( out.str() ) == true)
			{
			cout << "Measuring time : " << tstep * n << endl;
			readFromFile(out.str(),psi);
			double entropy = entanglement_entropy( &psi , N , N/2);
			entEntropy.push_back(entropy);
			}
		n += nmeas;
		} while( fileExists( out.str() ) == true);
	
	n -= 2 * nmeas;
	
	ofstream SaveFile(save_file.str().c_str());		
	SaveFile << setprecision(10) << fixed;
	
	for( unsigned int j = 0 ; j < entEntropy.size() ; j++ )
		{
		SaveFile << j * nmeas * tstep << " " << entEntropy[j] << "\n";
		}
		
	SaveFile.close();	
	
	out.str("");
	out << psi_file.str() << n;
	cout << "Last file opened is " << out.str() << endl;
	
	return 0;
}
