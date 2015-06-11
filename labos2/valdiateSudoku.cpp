#include <iostream>
#include <fstream>
#include <sstream>
#include <stdlib.h>
using namespace std;


int main(int argc, char *argv[]) {
	if (argc != 2) {
		cout << "[ERROR] Invalid number of arguments (" << argc << ") expected 2" << endl;
		exit(1);
	}

	ifstream file(argv[1]);
	if (file) {
		string line;
		unsigned int M[9][9];

		for (int i = 0; i < 9; ++i) {
			getline(file, line);
	 	   	istringstream iss(line);

			for (int j = 0; j < 9; ++j)
				iss >> M[i][j];
		}
		cout << "-----------------------------------" << endl;
		cout << "\t\tMATRIX" << endl << endl;
		for (int i = 0; i < 9; ++i) {
			cout << "\t";
			for (int j = 0; j < 9; ++j) {
				cout << M[i][j] << " ";
			}
			cout << endl;
		}
		cout << "-----------------------------------" << endl << endl;
		
		// ROW test (the sum of elements in each row must be 1+2+3+4+5+6+7+8+9 = 45)
		for (int i = 0; i < 9; ++i) {
			cout << "Check row " << i << "." << endl;
			int sum = 0;
			for (int j = 0; j < 9; ++j)
				sum += M[i][j];
		
			if (sum != 45)
				cout << "[ERROR] ROW " << i << " IS INCORRECT!" << endl;
		}

		// COL test (the sum of elements in each column must be 1+2+3+4+5+6+7+8+9 = 45)
		for (int j = 0; j < 9; ++j) {
			cout << "Check column " << j << "." << endl;
	
			int sum = 0;
			for (int i = 0; i < 9; ++i)
				sum += M[i][j];
		
			if (sum != 45)
				cout << "[ERROR] COLUMN " << j << " IS INCORRECT!" << endl;
		}

		// CUBE test (the sum of elements in each 3x3 sub-matrix must be 1+2+3+4+5+6+7+8+9 = 45)
		for (int x = 0; x < 3; ++x) {
			for (int y = 0; y < 3; ++y) {
				cout << "Check [" << x << "," << y << "] 3x3 sub-matrix." << endl;

				// [x,y] sub-matrix
				int sum = 0;
				for (int i = 0; i < 3; ++i) {
					for (int j = 0; j < 3; ++j)
						sum += M[i+3*x][j+3*y];
				}
				if (sum != 45)
					cout << "[ERROR] SUB-MATRIX [" << x << "," << y << "] IS INCORRECT!" << endl;
			}
		}

		cout << endl << "\t...all tests passed!" << endl;
	}
	else {cout << "[ERROR] Could not open <" << file << "> file." << endl; exit(1); }	
}