
syntax match globalVariableWithPrefix "g_\S*\>"
syntax match staticVariableWithPrefix "s_\S*\>"
call s:highlightColor('globalVariableWithPrefix', '#fe8019')
call s:highlightColor('staticVariableWithPrefix', '#fe8019')
