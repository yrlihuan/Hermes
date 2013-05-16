#include <vector>
#include <string>
#include <iostream>

#include <Python.h>
#include "serializer.h"

#include "py_level2.h"

using namespace std;
using namespace hermes;

static PyObject *CS_load_level2(PyObject *self, PyObject *args)
{
  const char *filename;
  int start = 0;
  int end = -1;
  if (!PyArg_ParseTuple(args, "s|ii", &filename, &start, &end))
    return NULL;

  PyLevel2Data *out = (PyLevel2Data*)PyLevel2Data_new(&PyLevel2DataType, NULL, NULL);

  vector<Level2Data> &dataOut = *(out->pVector);
  Serializer serializer;

  string f = filename;
  if (f.find(".csv") != string::npos) {
    serializer.loadCsvFile(f, dataOut);
  }
  else if (f.find(".dat") != string::npos) {
    serializer.loadDatFile(f, dataOut, start, end);
  }
  else {
    return NULL;
  }

  out->size = dataOut.size();
  out->pData = &dataOut[0];
  return (PyObject*)out;
}

extern "C" void initcstorage()
{
    if (PyType_Ready(&PyLevel2DataType) < 0)
        return;

   static PyMethodDef mbMethods[] = {
     {"load_level2", CS_load_level2, METH_VARARGS},

     {NULL, NULL, NULL} /*sentinel，哨兵，用来标识结束*/
   };

   // PyObject *m = Py_InitModule("cstorage", mbMethods);
   PyObject *module = Py_InitModule("cstorage", mbMethods);

   Py_INCREF(&PyLevel2DataType);
   PyModule_AddObject(module, "Level2Accessor", (PyObject*)&PyLevel2DataType);

   PyEval_InitThreads();
}

