
# coding: utf-8

# In[15]:

import os
import re
pattern = r'([a-zA-Z]:/(((?![<>:"/|?*]).)+((?<![ .])/)?)*)'
regex = re.compile(pattern)
filename = r"D:\Work\lib\caffe\build\install\cmake\hdf5-targets.cmake"
with open(filename, 'r') as f:
    content = f.read()


# In[22]:

basepath = os.path.abspath(os.path.dirname(filename))
basepath
prefix = basepath.replace('\\', '/')


# In[25]:

matches = regex.findall(content)
for m in matches:
    path = os.path.join(basepath, os.path.relpath(m[0], basepath))
    path = path.replace('\\', '/')
    path = path.replace(prefix, '${CMAKE_CURRENT_LIST_DIR}')
    content = content.replace(m[0], path)
print(content)


# In[ ]:



