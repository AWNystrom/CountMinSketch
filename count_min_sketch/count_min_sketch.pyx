from __future__ import division
from xxhash import xxh64
import numpy as np
cimport numpy as np

DTYPE = np.int64
ctypedef np.int64_t DTYPE_t

cdef class CountMinSketch:
    cdef np.ndarray rows, count
    cdef public np.int w, d, shift_by
    def __init__(self, np.int _w=None, np.int _d=None, np.float _delta=None, np.float _epsilon=None):
        """
        CountMinSketch is an implementation of the count min sketch 
        algorithm that probabilistically counts string frequencies.

        You must either supply w and d directly, or let them be calculated form error,
        delta, and epsilon. If You choose the latter, then w = ceil(error/epsilon) and
        d = ceil(ln(1.0/delta)) where the error in answering a query is within a factor 
        of epsilon with probability delta.

        Parameters
        ----------
        w : the number of columns in the count matrix
        d : the number of rows in the count matrix
        delta : (not applicable if w and d are supplied) the probability of query error
        epsilon : (not applicable if w and d are supplied) the query error factor

        bits : The size of the hash output space

        For the full paper on the algorithm, see the paper
        "An improved data stream summary: the count-min sketch and its -
        applications" by Cormode and Muthukrishnan, 2003.
        """

        if _w is not None and _d is not None:
            self.w = _w
            self.d = _d
        elif _delta is not None and _epsilon is not None:
            self.w = <DTYPE_t>(np.ceil(np.e / _epsilon))
            self.d = <DTYPE_t>(np.ceil(np.log(1./_delta)))
        else:
            raise Exception(
                "You must either supply both w and d or delta and epsilon.")

        self.count = np.zeros((self.d, self.w), dtype=DTYPE)
        self.rows = np.arange(self.d)
        self.shift_by = <DTYPE_t>(np.ceil(np.log(self.w) / np.log(2)))
        
        self.mask np.ndarray np.randint(0, 2147483647)

    def get_columns(self, string the_string):
        cdef bytearray some_bytes = bytearray(the_string)
        cdef DTYPE w = self.w
        cdef np.ndarray[DTYPE_t, ndim=1] hashes = np.ndarray(shape=(self.d,), dtype=DTYPE, order='C')
        cdef DTYPE_t h = xxh64(some_bytes).intdigest()
        cdef DTYPE shift_by = self.shift_by
        
        cdef DTYPE i = 0, d = self.d

        while i < d:
            some_bytes[0] ^ i
            hashes[i] = h % w
            h >>= shift_by
            if h < w and i+1 < d:
                some_bytes[0] ^ i
                h = xxh32(some_bytes).intdigest()
          i += 1

        return hashes

    def update(self, bytes a, DTYPE_t val=1):
        #h, in_cache = self.cache.lookup(a)
        cdef np.ndarray[DTYPE_t, ndim=1] h = self.get_columns(a)
        self.count[self.rows, h] += val

    def query(self, bytes a):
        cdef np.ndarray[DTYPE_t, ndim=1] h = self.get_columns(a)
        return self.count[self.rows, h].min()

    def __getitem__(self, bytes a):
        return self.query(a)

    def __setitem__(self, bytes a, DTYPE_t val):
        cdef DTYPE_t cur = self.query(a)
        self.update(a, val - cur)