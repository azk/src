#include <mex.h>

#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/objdetect/objdetect.hpp>

#include <string>
#include <vector>

using namespace std;
using namespace cv;

CascadeClassifier classifier;

void mexFunction(int outputSize, mxArray *output[], int inputSize, const mxArray *input[])
{
	if (inputSize != 4)
		mexErrMsgTxt("Usage: FaceDetect2 <haar cascade file> <image> <Min neighbours> <Scale factor>");

	if ( !mxIsChar(input[0]))
		mexErrMsgTxt("Input 1 must be a string.");

    if ((mxIsDouble(input[1])) || mxGetNumberOfDimensions(input[1]) != 2)
    	mexErrMsgTxt("Input image must be an 8-bit gray scale image");

    if (!mxIsDouble(input[3]))
    	mexErrMsgTxt("Input 4 must be a real number");

    if (!mxIsDouble(input[2]))
    	mexErrMsgTxt("Input 3 must be a positive integer");

	if (classifier.empty())
	{
		string s(mxArrayToString(input[0]));
		mexPrintf("Loading cascade file: %s",s.c_str());
		classifier.load(s);
	}

	int numCols = int(mxGetN(input[1]));
	int numRows = int(mxGetM(input[1]));


	Mat image = Mat(numCols,numRows,CV_8U,(int*)mxGetData(input[1]));

	double scaleFactor = (*mxGetPr(input[3]));
	int minNeighbours = (int)(*mxGetPr(input[2]));


	vector<Rect> faceVector;

	mexPrintf("Running face detection with parameters:\n"
			 "scaleFactor = %lf\n minNeighbors = %d\n\n",scaleFactor,minNeighbours);
	classifier.detectMultiScale(image.t(),faceVector,scaleFactor,minNeighbours,0,
								Size(30,30)/*add min size*/);

	double* Data;
    if (!faceVector.empty())
    {
        output[0] = mxCreateDoubleMatrix(faceVector.size(), 4, mxREAL);
        Data = mxGetPr(output[0]); // Get the pointer to output variable
        // Iterate trou each of the detected faces
        int i=0;
        for( vector<Rect>::iterator it = faceVector.begin()
        		; it != faceVector.end() ; it++,i++ )
        {
           /* The Data pointer again has to be filled in a column wise manner
            * The first column will contain the x location of all faces
            * while column two will contain y location of all faces */
           Data [i] = it->x + 1;
           Data [i+faceVector.size()] = it->y + 1;
           Data [i+faceVector.size()*2] = it->width;
           Data [i+faceVector.size()*3] = it->height;
           // Debug
           // printf ("%d %d %d %d\n", r->x, r->y, r->width, r->height);
        }
    }
    else
    {
        output[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
        Data = mxGetPr(output[0]); // Get the pointer to output variable
        Data[0] = -1;
    }

}
