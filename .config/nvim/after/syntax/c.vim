syntax match cFunction "\v<\w+(\()@="
syntax match cMacros "\v^#<\w+>"
syntax match cType "\v<\w+_t>\s+(<\w+>)@="
syntax match cStructure "\v(<(struct|enum)>\s+)@<=<\w+>(::)@!"
syntax clear cSpecial
