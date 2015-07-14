/*
 * _coder_GetINSCompensateFromVNS_mex.cpp
 *
 * Code generation for function 'GetINSCompensateFromVNS'
 *
 */

/* Include files */
#include "mex.h"
#include "GetINSCompensateFromVNS.h"

/* Function Declarations */
static void GetINSCompensateFromVNS_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

/* Variable Definitions */
emlrtContext emlrtContextGlobal = { true, false, EMLRT_VERSION_INFO, NULL, "GetINSCompensateFromVNS", NULL, false, {2045744189U,2170104910U,2743257031U,4284093946U}, NULL };
void *emlrtRootTLSGlobal = NULL;

/* Function Definitions */
static void GetINSCompensateFromVNS_mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  const mxArray *outputs[4];
  const mxArray *inputs[3];
  int n = 0;
  int nOutputs = (nlhs < 1 ? 1 : nlhs);
  int nInputs = nrhs;
  emlrtStack st = { NULL, NULL, NULL };
  /* Module initialization. */
  GetINSCompensateFromVNS_initialize(&emlrtContextGlobal);
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, mxINT32_CLASS, 3, mxCHAR_CLASS, 23, "GetINSCompensateFromVNS");
  } else if (nlhs > 4) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, mxCHAR_CLASS, 23, "GetINSCompensateFromVNS");
  }
  /* Temporary copy for mex inputs. */
  for (n = 0; n < nInputs; ++n) {
    inputs[n] = prhs[n];
  }
  /* Call the function. */
  GetINSCompensateFromVNS_api(inputs, outputs);
  /* Copy over outputs to the caller. */
  for (n = 0; n < nOutputs; ++n) {
    plhs[n] = emlrtReturnArrayR2009a(outputs[n]);
  }
  /* Module finalization. */
  GetINSCompensateFromVNS_terminate();
}

void GetINSCompensateFromVNS_atexit_wrapper(void)
{
   GetINSCompensateFromVNS_atexit();
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Initialize the memory manager. */
  mexAtExit(GetINSCompensateFromVNS_atexit_wrapper);
  /* Dispatch the entry-point. */
  GetINSCompensateFromVNS_mexFunction(nlhs, plhs, nrhs, prhs);
}
/* End of code generation (_coder_GetINSCompensateFromVNS_mex.cpp) */