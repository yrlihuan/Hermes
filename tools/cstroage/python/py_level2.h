
#ifndef _PY_LEVEL2_H_
#define _PY_LEVEL2_H_

#include <vector>
#include "level2.h"

typedef struct {
    PyObject_HEAD

    std::vector<hermes::Level2Data> *pVector;
    hermes::Level2Data *pData;
    int size;
    int pos;

} PyLevel2Data;

extern PyObject *PyLevel2Data_new(PyTypeObject *type, PyObject *args, PyObject *kwds);
extern PyTypeObject PyLevel2DataType;

#endif
