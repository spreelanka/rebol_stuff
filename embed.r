REBOL[Title: "Binary Embedder"]
system/options/binary-base: 64
file: to-file request-file/only
data: read/binary file
print data  
halt