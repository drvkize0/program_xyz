// BVHTransformCTest.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "BVHTransform_c.h"


int _tmain(int argc, _TCHAR* argv[])

{
	double BVHData[354] = { -393.12, 63.36, -200.11, -6.98, -0.27, 0.11, -9.07, -0.02, 0.06, 66.20, -54.12, -81.76, 0.39, -41.78, 0.19, 159.32, 62.94, 156.77, 0.36, -41.83, -0.16, 9.69, 28.84, 7.20, 9.11, -0.05, 0.03, -61.06, -57.31, 76.35, -0.11, -42.03, 0.09, -44.67, 71.12, -75.12, 0.42, -41.95, -0.02, 13.01, 60.21, -0.83, 0.02, 11.97, -0.10, 6.29, 11.68, -1.54, -0.02, 9.80, -0.29, 1.55, 2.95, -0.50, -0.00, 10.20, -0.22, 2.50, 4.88, -0.79, 0.04, 9.74, -0.04, -0.01, -0.73, 0.12, 0.03, 10.42, -0.02, -0.01, -0.73, 0.12, 0.02, 6.50, 0.01, -0.64, -13.26, 2.21, -3.18, 6.94, 0.01, -8.89, 12.31, 12.94, -15.98, -0.05, -0.09, 14.32, -3.40, 47.21, -26.54, -0.03, -0.10, 99.38, 13.01, 12.83, -25.98, 0.04, 0.10, 1.92, 23.33, -16.15, -2.70, 0.21, 3.39, 0.00, 0.00, 0.00, -2.75, -0.64, 2.83, 0.00, 0.00, 0.00, -2.13, -0.81, 1.59, 0.00, 0.00, 0.00, -3.50, 0.55, 2.15, 0.00, 0.00, 0.00, -5.67, -0.10, 1.09, 0.00, 0.00, 0.00, -3.92, -0.19, 0.20, 0.00, 0.00, 0.00, -2.22, -0.14, -0.08, 0.00, 0.00, 0.00, -3.67, 0.56, 0.82, 0.00, 0.00, 0.00, -5.62, -0.09, 0.34, 0.00, 0.00, 0.00, -4.27, -0.29, -0.20, 0.00, 0.00, 0.00, -2.67, -0.21, -0.24, 0.00, 0.00, 0.00, -3.65, 0.59, -0.14, 0.00, 0.00, 0.00, -5.00, -0.02, -0.52, 0.00, 0.00, 0.00, -3.65, -0.29, -0.74, 0.00, 0.00, 0.00, -2.55, -0.19, -0.44, 0.00, 0.00, 0.00, -3.43, 0.51, -1.30, 0.00, 0.00, 0.00, -4.49, -0.02, -1.18, 0.00, 0.00, 0.00, -2.85, -0.16, -0.90, 0.00, 0.00, 0.00, -1.77, -0.14, -0.66, 0.00, 0.00, 0.00, 3.22, 6.92, -0.04, 4.89, 1.15, 10.12, 16.02, -0.03, -0.12, -16.94, -1.78, -66.87, 26.53, -0.14, -0.05, -79.55, 23.34, 9.32, 26.00, -0.13, 0.03, -1.14, -4.28, -11.03, 2.70, 0.21, 3.39, 0.00, 0.00, 0.00, 2.75, -0.64, 2.83, 0.00, 0.00, 0.00, 2.13, -0.81, 1.59, 0.00, 0.00, 0.00, 3.50, 0.55, 2.15, 0.00, 0.00, 0.00, 5.67, -0.10, 1.08, 0.00, 0.00, 0.00, 3.92, -0.19, 0.20, 0.00, 0.00, 0.00, 2.22, -0.14, -0.08, 0.00, 0.00, 0.00, 3.67, 0.56, 0.82, 0.00, 0.00, 0.00, 5.62, -0.09, 0.34, 0.00, 0.00, 0.00, 4.27, -0.29, -0.20, 0.00, 0.00, 0.00, 2.67, -0.21, -0.24, 0.00, 0.00, 0.00, 3.65, 0.59, -0.14, 0.00, 0.00, 0.00, 5.00, -0.02, -0.52, 0.00, 0.00, 0.00, 3.65, -0.29, -0.74, 0.00, 0.00, 0.00, 2.55, -0.19, -0.44, 0.00, 0.00, 0.00, 3.43, 0.51, -1.30, 0.00, 0.00, 0.00, 4.49, -0.02, -1.18, 0.00, 0.00, 0.00, 2.85, -0.16, -0.90, 0.00, 0.00, 0.00, 1.77, -0.14, -0.66, 0.00, 0.00, 0.00 };
	double NaoData[25];


	BVHTransform_c(BVHData,NaoData);
	return 0;
}
