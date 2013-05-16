#include <Python.h>
#include "structmember.h"

#include "py_level2.h"

using namespace std;
using namespace hermes;

PyObject *
PyLevel2Data_new(PyTypeObject *type, PyObject *args, PyObject *kwds)
{
    PyLevel2Data *self;

    self = (PyLevel2Data*)type->tp_alloc(type, 0);
    if (self != NULL) {
      self->pVector = new vector<Level2Data>();
      self->size = 0;
      self->pos = 0;
    }

    return (PyObject*)self;
}

static void PyLevel2Data_dealloc(PyLevel2Data *self)
{
  if (self->pVector) {
    delete self->pVector;
  }
}

static PyObject*  count(PyObject *self, PyObject *args)
{
  return Py_BuildValue("i", ((PyLevel2Data*)self)->size);
}

static PyObject*  pos(PyObject *self, PyObject *args)
{
  return Py_BuildValue("i", ((PyLevel2Data*)self)->pos);
}

static PyObject*  seek(PyObject *self, PyObject *args)
{
  int newPos = 0;
  PyArg_ParseTuple(args, "i", &newPos);
  if (newPos >= 0 && newPos < ((PyLevel2Data*)self)->size) {
    ((PyLevel2Data*)self)->pos = newPos;
    Py_RETURN_TRUE;
  }
  else {
    Py_RETURN_FALSE;
  }
}

static PyObject*  next(PyObject *self, PyObject *args)
{
  PyLevel2Data *self2 = (PyLevel2Data*)self;
  if (self2->pos + 1 < self2->size) {
    self2->pos++;
    Py_RETURN_TRUE;
  }
  else {
    Py_RETURN_FALSE;
  }
}

static PyObject*  dataLocalTS(PyObject *obj, PyObject *args)
{
  PyLevel2Data *self = (PyLevel2Data*)obj;
  return Py_BuildValue("d", (self->pData+self->pos)->localTS());
}

static PyObject*  dataRemoteTS(PyObject *obj, PyObject *args)
{
  PyLevel2Data *self = (PyLevel2Data*)obj;
  return Py_BuildValue("d", (self->pData+self->pos)->remoteTS());
}

static PyObject*  dataSecurityId(PyObject *obj, PyObject *args)
{
  PyLevel2Data *self = (PyLevel2Data*)obj;
  return Py_BuildValue("i", (self->pData+self->pos)->securityId());
}

static PyObject*  dataVolumeTraded(PyObject *obj, PyObject *args)
{
  PyLevel2Data *self = (PyLevel2Data*)obj;
  return Py_BuildValue("i", (self->pData+self->pos)->volumeTraded());
}

static PyObject*  dataOrderTraded(PyObject *obj, PyObject *args)
{
  PyLevel2Data *self = (PyLevel2Data*)obj;
  return Py_BuildValue("i", (self->pData+self->pos)->orderTraded());
}

static PyObject*  dataTotalOfferQty(PyObject *obj, PyObject *args)
{
  PyLevel2Data *self = (PyLevel2Data*)obj;
  return Py_BuildValue("i", (self->pData+self->pos)->totalOfferQty());
}

static PyObject*  dataTotalBidQty(PyObject *obj, PyObject *args)
{
  PyLevel2Data *self = (PyLevel2Data*)obj;
  return Py_BuildValue("i", (self->pData+self->pos)->totalBidQty());
}

static PyObject*  dataPrice(PyObject *obj, PyObject *args)
{
  PyLevel2Data *self = (PyLevel2Data*)obj;
  return Py_BuildValue("d", (self->pData+self->pos)->price());
}

static PyObject*  dataAvgOfferPrice(PyObject *obj, PyObject *args)
{
  PyLevel2Data *self = (PyLevel2Data*)obj;
  return Py_BuildValue("d", (self->pData+self->pos)->avgOfferPrice());
}

static PyObject*  dataAvgBidPrice(PyObject *obj, PyObject *args)
{
  PyLevel2Data *self = (PyLevel2Data*)obj;
  return Py_BuildValue("d", (self->pData+self->pos)->avgBidPrice());
}

static PyMethodDef PyLevel2Data_methods[] = {
    {"count", (PyCFunction)count, METH_NOARGS, ""},
    {"pos", (PyCFunction)pos, METH_NOARGS, ""},
    {"seek", (PyCFunction)seek, METH_VARARGS, ""},
    {"next", (PyCFunction)next, METH_NOARGS, ""},

    {"dataLocalTS",         (PyCFunction)dataLocalTS, METH_NOARGS, ""},
    {"dataRemoteTS",        (PyCFunction)dataRemoteTS, METH_NOARGS, ""},
    {"dataSecurityId",      (PyCFunction)dataSecurityId, METH_NOARGS, ""},
    {"dataVolumeTraded",    (PyCFunction)dataVolumeTraded, METH_NOARGS, ""},
    {"dataOrderTraded",     (PyCFunction)dataOrderTraded, METH_NOARGS, ""},
    {"dataTotalOfferQty",   (PyCFunction)dataTotalOfferQty, METH_NOARGS, ""},
    {"dataTotalBidQty",     (PyCFunction)dataTotalBidQty, METH_NOARGS, ""},
    {"dataPrice",           (PyCFunction)dataPrice, METH_NOARGS, ""},
    {"dataAvgOfferPrice",   (PyCFunction)dataAvgOfferPrice, METH_NOARGS, ""},
    {"dataAvgBidPrice",     (PyCFunction)dataAvgBidPrice, METH_NOARGS, ""},
    {NULL}  /* Sentinel */
};

PyTypeObject PyLevel2DataType = {
    PyObject_HEAD_INIT(NULL)
    0,                                        /*ob_size*/
    "cstorage.level2",                        /*tp_name*/
    sizeof(PyLevel2Data),                     /*tp_basicsize*/
    0,                                        /*tp_itemsize*/
    (destructor)PyLevel2Data_dealloc,         /*tp_dealloc*/
    0,                                        /*tp_print*/
    0,                                        /*tp_getattr*/
    0,                                        /*tp_setattr*/
    0,                                        /*tp_compare*/
    0,                                        /*tp_repr*/
    0,                                        /*tp_as_number*/
    0,                                        /*tp_as_sequence*/
    0,                                        /*tp_as_mapping*/
    0,                                        /*tp_hash */
    0,                                        /*tp_call*/
    0,                                        /*tp_str*/
    0,                                        /*tp_getattro*/
    0,                                        /*tp_setattro*/
    0,                                        /*tp_as_buffer*/
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE, /*tp_flags*/
    "Level2 Data Accessor",                   /* tp_doc */
    0,                                        /* tp_traverse */
    0,                                        /* tp_clear */
    0,                                        /* tp_richcompare */
    0,                                        /* tp_weaklistoffset */
    0,                                        /* tp_iter */
    0,                                        /* tp_iternext */
    PyLevel2Data_methods,                     /* tp_methods */
    0,                                        /* tp_members */
    0,                                        /* tp_getset */
    0,                                        /* tp_base */
    0,                                        /* tp_dict */
    0,                                        /* tp_descr_get */
    0,                                        /* tp_descr_set */
    0,                                        /* tp_dictoffset */
    0,                                        /* tp_init */
    0,                                        /* tp_alloc */
    PyLevel2Data_new,                         /* tp_new */
};

