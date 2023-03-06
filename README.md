# ConvertStringtoInt
Conversor de String de até 64 bits para Inteiro em Assembly x64 Linux

**Problema:**

*Construa um código que converta o texto apresentado em entrada da seção .data para um inteiro e armazene em resultado na seção .bss.*

**Observações:**

**Obs.1**: */("[-]?[0-9]+",0)/ é uma expressão regular usada para determinar o que pode ser alocado na variável inicializada entrada, e seu significado é: entrada pode receber uma string (delimitada pela primeira e segunda aspas duplas). A  string  pode conter exatamente zero ou um caractere “menos”, determinado pela regra  [-]?, seguido de um ou mais caracteres “dígitos”, determinado pela [0-9]+, seguido exatamente por , 0.*

***Exemplos de entradas válidas:***

entrada   : db “98563255”, 0 

entrada   : db “-3”, 0

entrada   : db “-10000000000000000000”, 0 ; >2^63, maior do que um int x64 sinalizado!

***Exemplos de entradas inválidas:***

entrada   : db “+98563255”, 0

entrada   : db “menos3”, 0

entrada   : db “-3”___ ; , 0 ausente

entrada   : db “100000000000000a0000”, 0

*Entradas inválidas nunca devem ser adicionadas no código, portanto, considera-se que não é necessário tratar estas entradas.*


**Obs.2**: *nota-se a existência da variável não inicializada isCastValid, considerada booleana com a seguinte regra:*

isCastValid = 1 se a conversão de string para inteiro x64 acontecer sem problemas, o valor de resultado é válido.

isCastValid = 0 se a conversão de string para inteiro x64 acontecer com problemas isto é, o valor da string não pode ser representado em inteiro x64, o valor de resultado é inválido.

