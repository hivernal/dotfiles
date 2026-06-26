syntax match cppStatement "\v^namespace>\s*(\{)@="
syntax match cppStatement "\v<class>"
syntax match cppType "\v(<\w+>::)@<=<\w+>(\{|\&+|\*|\<|\s+\w+)@="
