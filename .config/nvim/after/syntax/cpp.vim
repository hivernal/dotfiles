syntax match cppStatement "\v^namespace>\s*(\{)@="
syntax match cppStatement "\vclass>"
syntax match cppType "\v(<\w+>::)@<=<\w+>(\{|\&+|\*|\<|\s+\w+)@="
