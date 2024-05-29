#
# IAC 2023/2024 k-means
# 
# Grupo:27
# Campus:Alameda
#
# Autores:
# 109623, Tiago Lobo
# 109989, Pedro Aldeia
# 110438, Dinis Pimentel
#
# Tecnico/ULisboa


# ALGUMA INFORMACAO ADICIONAL PARA CADA GRUPO:
# - A "LED matrix" deve ter um tamanho de 32 x 32
# - O input e' definido na seccao .data. 
# - Abaixo propomos alguns inputs possiveis. Para usar um dos inputs propostos, basta descomentar 
#   esse e comentar os restantes.
# - Encorajamos cada grupo a inventar e experimentar outros inputs.
# - Os vetores points e centroids estao na forma x0, y0, x1, y1, ...


# Variaveis em memoria
.data

#Input A - linha inclinada
#n_points:    .word 9
#points:      .word 0,0, 1,1, 2,2, 3,3, 4,4, 5,5, 6,6, 7,7 8,8

#Input B - Cruz
#n_points:    .word 5
#points:     .word 4,2, 5,1, 5,2, 5,3 6,2

#Input C
#n_points:    .word 23
#points: .word 0,0, 0,1, 0,2, 1,0, 1,1, 1,2, 1,3, 2,0, 2,1, 5,3, 6,2, 6,3, 6,4, 7,2, 7,3, 6,8, 6,9, 7,8, 8,7, 8,8, 8,9, 9,7, 9,8

#Input D
n_points:    .word 30
points:      .word 16, 1, 17, 2, 18, 6, 20, 3, 21, 1, 17, 4, 21, 7, 16, 4, 21, 6, 19, 6, 4, 24, 6, 24, 8, 23, 6, 26, 6, 26, 6, 23, 8, 25, 7, 26, 7, 20, 4, 21, 4, 10, 2, 10, 3, 11, 2, 12, 4, 13, 4, 9, 4, 9, 3, 8, 0, 10, 4, 10

#InputExtra A
#n_points:     .word 4
#points:       .word 5,1 , 5,5, 3,3, 7, 3

#InputExtra B
#n_points:     .word 4
#points:       .word 0,0 , 31,31, 0,31, 31, 0

#InputExtra C
#n_points:     .word 11
#points:       .word 0,0 , 0,1 , 0,2 , 0,3 , 0,4 , 0,5 , 0,6 , 0,7 , 0,8 , 0,9 , 0,10

# Valores de centroids e k a usar na 1a parte do projeto:
#centroids:   .word 0,0
#k:           .word 1

# Valores de centroids, k e L a usar na 2a parte do prejeto:
centroids:   .word 0,0, 3,5, 0,10
k:           .word 3
L:           .word 10

# Abaixo devem ser declarados o vetor clusters (2a parte) e outras estruturas de dados
# que o grupo considere necessarias para a solucao:
clusters:     .zero 120


#Definicoes de cores a usar no projeto 

colors:      .word 0xff0000, 0x00ff00, 0x0000ff  # Cores dos pontos do cluster 0, 1, 2, etc.

.equ         black      0
.equ         white      0xffffff

.equ         printInt       1
.equ         printString    4


# !Nota ao utilizador: Caso queira ver a execu  o de cada printPoint apesar das suas >= n chamadas,
# sinta-se   vontade para modificar a constante abaixo para 1.
.equ    shouldPrintMessage_PrintPoint   0

messageCleanScreen:             .string    "cleanScreen executado.\n"
messagePrintPoint:              .string    " - ponto mostrado por printPoint.\n"
messagePrintClusters:           .string    "printClusters executado.\n"
messagePrintCentroids:          .string    "printCentroids executado.\n"
messageCalculateCentroids:      .string    "calculateCentroids executado.\n"
messageEndMainSingleCluster:    .string    "Procedimento mainSingleCluster terminou execucao.\n"


stringStartP:                   .string    "("
stringEndP:                     .string    ")"
stringCommaSpace:               .string    ", "



# Codigo
 
.text
    # Chama funcao principal da 1a parte do projeto
    #jal mainSingleCluster

    # Descomentar na 2a parte do projeto:
    jal mainKMeans
    
    #Termina o programa (chamando chamada sistema)
    li a7, 10
    ecall


### printPoint
# Pinta o ponto (x,y) na LED matrix com a cor passada por argumento
# Nota: a implementacao desta funcao ja' e' fornecida pelos docentes
# E' uma funcao auxiliar que deve ser chamada pelas funcoes seguintes que pintam a LED matrix.
# N o altera registos tempor rios.
# Argumentos:
# a0: x
# a1: y
# a2: cor
# Altera a0-a3, t0
printPoint:
    addi sp, sp, -4
    sw a0, 0(sp)
    
    li a3, LED_MATRIX_0_HEIGHT
    sub a1, a3, a1
    addi a1, a1, -1
    li a3, LED_MATRIX_0_WIDTH
    mul a3, a3, a1
    add a3, a3, a0 
    slli a3, a3, 2
    li a0, LED_MATRIX_0_BASE  # a0 = &LED_MATRIX
    add a3, a3, a0   
    sw a2, 0(a3)
    
    li a0, shouldPrintMessage_PrintPoint 
    beqz a0, skipPrintPrintPoint
    
    la a0, stringStartP
    li a7, printString
    ecall

    lw a0, 0(sp)
    li a7, printInt
    ecall

    la a0, stringCommaSpace
    li a7, printString
    ecall

    addi a0, a1, 0
    li a7, printInt
    ecall

    la a0, stringEndP
    li a7, printString
    ecall

    la a0, messagePrintPoint  
    li a7, printString
    ecall
    
skipPrintPrintPoint:    
addi sp, sp, 4
jr ra
    

### cleanScreen
# Limpa todos os pontos do ecr 
# Argumentos: nenhum
# Retorno: nenhum
# Altera: a0, a7, t0-t2 
cleanScreen:
    li t0, white
    li t1, LED_MATRIX_0_HEIGHT
    li t2, LED_MATRIX_0_WIDTH
    mul t1, t2, t1 # t1 - num leds
    slli t1, t1, 2 # t1 - num leds * 4
    li t2, LED_MATRIX_0_BASE  # => 1  addr
    add t1, t1, t2  # t1 - num leds * 4 + Base => ult addr
    
loopCleanScreen:
    beq t2,t1, outCleanScreen  
    sw t0, 0(t2)  # coloca a cor na mem ria
    addi t2, t2, 4
    j loopCleanScreen
outCleanScreen:

    la a0, messageCleanScreen
    li a7, printString
    ecall
    jr ra


### printClusters
# Pinta os agrupamentos na LED matrix com a cor correspondente.
# Argumentos: nenhum
# Retorno: nenhum
# Altera t0, t1, t2, t3, t4, t5
# Altera a0, a1, a2, a7

printClusters:
    # IMPLEMENTADO (1a parte) - POR IMPLEMENTAR (2a parte)
    la   t0, n_points    #t0-> n_points
    la   t1, points      #t1-> vetor points
    la   t3, clusters    #t3-> vetor clusters
    la   t4, colors      #t4-> vetor das cores
    lw   t0, 0(t0)
    #salvaguardar stack pointer:
    addi sp, sp, -4
    sw   ra, 0(sp)
loopPrintClusters:
    beq  t0, x0, outPrintClusters #se ja nao houverem pontos para dar print
    addi t0, t0, -1 
    lw   a0, 0(t1)       #vai buscar o x e y
    lw   a1, 4(t1)  
    lw   t5, 0(t3)       #vai buscar o numero do cluster do ponto (t5--> endere�o final da cor do ponto)
    slli t5, t5, 2
    add  t5, t5, t4      #calcula o endereco da cor do cluster
    lw   a2, 0(t5)       #vai buscar a cor
    addi t3, t3, 4
    addi t1, t1, 8        #passa para o proximo ponto
    jal  ra, printPoint   #pinta o ponto (anterior) no led
    j    loopPrintClusters
outPrintClusters:
    #vai buscar os valores de antes
    lw   ra, 0(sp)
    addi sp, sp, 4
    la a0, messagePrintClusters
    li a7, printString
    ecall
    jr ra                 #volta para o endereco anterior
### printCentroids
# Pinta os centroides na LED matrix
# Nota: deve ser usada a cor preta (black) para todos os centroides
# Argumentos: nenhum
# Retorno: nenhum
# Altera: t0-t1, a0-a2, a7
printCentroids:
    # IMPLEMENTADO (1a parte) - POR IMPLEMENTAR (2a parte)
    addi sp, sp, -4
    sw ra, 0(sp)
    
    la t0, k  # t0 = &k
    lw t0, 0(t0) # t0 = *t0
    la t1, centroids  # first item addr, centroids
    slli t0, t0, 3 # t0 = t0 * 8  [k*4*2]
    add t0, t1, t0  # t0 = [centroids_out_of_bounds]
loopPrintCentroids:
    beq t1, t0, outPrintCentroids  # se t1 == t0 [addr_centroid == centroids_out_of_bounds]
    
    lw a0, 0(t1)
    lw a1, 4(t1)
    li a2, black
    jal printPoint  # print(t1.x, t1.y, black) ; t1 [addr_centroid]
    
    addi t1, t1, 8
    j loopPrintCentroids
outPrintCentroids:
    la a0, messagePrintCentroids
    li a7, printString
    ecall
    lw ra, 0(sp)
    addi sp, sp 4
    jr ra
    
### calculateCentroids
# Calcula os k centroides, a partir da distribuicao atual de pontos associados a cada agrupamento (cluster)
# Argumentos: nenhum
# Retorno: nenhum

calculateCentroids:
    # IMPLEMENTADO (1a parte) - POR IMPLEMENTAR (2a parte)
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    
    #la a2, points #endereço points
    lw a3, n_points #número de pontos
    add a3, a3, a3 #comprimento do array
    #la a4, clusters #endereço clusters
    add a5, x0, x0 #índice do cluster
    lw s0, k #número de clusters
    la s1, centroids
loopCalculateCentroids:
    la a2, points
    la a4, clusters
    jal ra, arrayAverage 
    sw a0, 0(s1) #guarda os valores no array 
    sw a1, 4(s1)
    addi a5, a5, 1
    addi s1, s1, 8
    addi s0, s0, -1
    bne s0, x0, loopCalculateCentroids
     
    la a0, messageCalculateCentroids
    li a7, printString
    ecall
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp 12
    jr ra
   
### arrayAverage
# Calcula as coordenadas (x, y) do ponto médio de um array de pontos
# Argumentos:  
# a2: points
# a3: n_points*2 (comprimento)
# a4: clusters
# a5: cluster index
# Retorno: 
# a0: x
# a1: y

arrayAverage:
    add a0, x0, x0 #retorno
    add a1, x0, x0 
    add t1, x0, x0 #counter
    addi t2, x0, 2 
    add t5, x0, x0
    add t6, x0, x0 #n_pontos_somados
loopArrayAverage:
    beq t1, a3, outArrayAverage   
    slli t3, t1, 2 
    add t3, t3, a2 
    lw t0, 0(t3) #t0 = A[counter]
    rem t4, t1, t2 #ver se é par
    bnez t4, oddArrayAverage #salto para o caso ímpar
    lw t5, 0(a4) # cluster index do ponto
    addi a4, a4, 4
    addi t1, t1, 1
    bne t5, a5, loopArrayAverage
    add a0, a0, t0 #caso par
    j loopArrayAverage
    
oddArrayAverage:
    addi t1, t1, 1
    bne t5, a5, loopArrayAverage
    add a1, a1, t0 #caso ímpar
    addi t6, t6, 1
    j loopArrayAverage  
    
outArrayAverage:
    div a0, a0, t6
    div a1, a1, t6

    jr ra


### mainSingleCluster
# Funcao principal da 1a parte do projeto.
# Argumentos: nenhum
# Retorno: nenhum
# Altera: t1, a0, a7
mainSingleCluster:
    
    addi sp, sp, -4
    sw   ra, 0(sp)
    
    #1. Coloca k=1 (caso nao esteja a 1)
    la    t0, k
    addi  t1, x0, 1
    sw    t1, 0(t0)

    #2. cleanScreen
    jal   ra, cleanScreen

    #3. printClusters
    jal  ra, printClusters
    
    #4. calculateCentroids
    jal   ra, calculateCentroids

    #5. printCentroids
    jal   ra, printCentroids

    #6. Termina
    la a0, messageEndMainSingleCluster
    li a7, printString
    ecall
    
    # Mensagem de fim de execucao
    lw    ra, 0(sp)
    addi  sp, sp, 4
    jr ra


### manhattanDistance
# Calcula a distancia de Manhattan entre (x0,y0) e (x1,y1)
# Argumentos:
# a0, a1: x0, y0
# a2, a3: x1, y1
# Retorno:
# a0: distance
# Altera a0, t0

manhattanDistance:
    # media das coordenadas dos pontos:
    bge  a2, a0, xtwoBiggManhattanDistance #se x1>=x0 jump
    sub  a0, a0, a2                        #x0-x1
    j    yCalcManhattanDistance
xtwoBiggManhattanDistance:
    sub  a0, a2, a0                        #x1-x0
yCalcManhattanDistance:
    bge  a3, a1, ytwoBiggManhattanDistance #se y1>=y0 jump
    sub  t0, a1, a3                        #x0-x1
    j    calcDistManhattanDistance
ytwoBiggManhattanDistance:
    sub  t0, a3, a1                        #x1-x0
    
calcDistManhattanDistance:
    # calcula distancia
    add  a0, t0, a0    #dist = dx+dy
    jr ra


### nearestCluster
# Determina o centroide mais perto de um dado ponto (x,y).
# Argumentos:
# a0, a1: (x, y) point
# Retorno:
# a0: cluster index
# Altera a0, a1, a2, a3

nearestCluster:
    # POR IMPLEMENTAR (2a parte)
    # salvaguardar dados (nomeadamente os 's', que v?o ser usados neste c?digo)
    addi sp, sp, -32
    sw   ra, 0(sp)
    sw   a0, 4(sp)
    sw   a1, 8(sp)
    sw   s0, 12(sp)
    sw   s1, 16(sp)
    sw   s2, 20(sp)
    sw   s3, 24(sp)
    sw   s4, 28(sp)
    # inicializa??o de tempor?rios e ir buscar dados (k, adress centroids)
    lw   s0, k
    addi s1, x0, 0
    la   s2, centroids
    addi s3, x0, 0
LoopNearestCluster:
    lw   a2, 0(s2)   #vai buscar o x e y do ponto
    lw   a3, 4(s2)
    jal  ra, manhattanDistance  #calcula distancia
    beq  s1, x0, firstIterNearestCluster
    bge  a0, s3, skipNearestCluster #se a distancia for maior do que a anterior da skip
firstIterNearestCluster:
    add  s4, s1, x0   #se n?o guarda o indice
    add  s3, a0, x0   #e guarda a distancia ao ponto
skipNearestCluster:
    #vai buscar os pontos a stack
    lw   a0, 4(sp)
    lw   a1, 8(sp)
    addi s1, s1, 1 #adiciona 1 a contagem
    addi s2, s2, 8
    bge  s0, s1, LoopNearestCluster # recomeca loop
    #poe o resultado pretendido em a0
    addi a0, s4, 0 
    #vai buscar os registos anteriores e espaco a stack
    lw   ra, 0(sp)
    lw   s0, 12(sp)
    lw   s1, 16(sp)
    lw   s2, 20(sp)
    lw   s3, 24(sp)
    lw   s4, 28(sp)
    addi sp, sp, 32

    jr ra


### attributeCluster
# Coloca no vetor cluster o ?ndice do cluster a que o ponto(do vetor) est? mais proximo
# Argumentos: nenhum
# Retorno: nenhum
# Altera registos: a0, a1, a2, a3

attributeCluster:
    #salvaguardar os registos (nomeadamente os 's')
    addi sp, sp, -20
    sw   ra, 0(sp)
    sw   s0, 4(sp)
    sw   s1, 8(sp)
    sw   s2, 12(sp)
    sw   s3, 16(sp)
    #incicializar registos
    la   s0, points   #s0 --> adress de points
    la   s1, clusters #s1 --> adress de clusters
    addi s2, x0, 0    #s2 --> iterador
    lw   s3, n_points #s3 --> numero de pontos
    #calcular nearest cluster e atribuir o cluster
loopAttributeCluster:
    lw   a0, 0(s0) #coloca os argumentos para chamar nearestCluster
    lw   a1, 4(s0)
    jal  ra, nearestCluster
    sw   a0, 0(s1) #coloca o indice no vetor cluster
    addi s0, s0, 8
    addi s1, s1, 4
    addi s2, s2, 1
    bgt  s3, s2, loopAttributeCluster
    #colocar de volta os registos anteriores
    lw   ra, 0(sp)
    lw   s0, 4(sp)
    lw   s1, 8(sp)
    lw   s2, 12(sp)
    lw   s3, 16(sp)
    addi sp, sp, 20
    jr   ra
    
    
### initializeCentroids
# Inicializa com valores pseudo-rand?micos [0;31] o vetor centroids
# Argumentos: nenhum
# Retorno: nenhum
# Altera: a0-a1, a7, t0-t6 | *centroids

initializeCentroids:
    addi t0, x0, 0  # Counter
    addi t1, x0, 0  # Counter agregado
    addi t4, x0, 31
    li t2, 5        # Limite at� necessitar mudar a seed: floor(32bits/5bits) => floor(6.4) = 6
    lw t3, k        # Limite geral (offset de 8)
    slli t3,t3, 1   # k*2 (offset de 4)
    addi a7, x0, 30
    ecall
    mul a0, a1, a0
    la t6, centroids
updateRandInitializeCentroids:
    addi t0, x0, 0  # Counter reset
    mul a0, a0, a0  # Next seed
    addi a1, a0, 0
loopInitializeCentroids:
    beq t1, t3, exitInitializeCentroids 
    beq t0, t2, updateRandInitializeCentroids

    and t5, a1, t4  # Pega 5 bits de a0, t4 � a m�scara. 0b11111 = 31
    srli a1, a1, 5

    sw t5, 0(t6)
    
    addi t0, t0, 1 # Incremento
    addi t1, t1, 1
    addi t6, t6, 4 # Avan�ar 4 no ptr
    j loopInitializeCentroids
exitInitializeCentroids:
    jr ra

### mainKMeans
# Executa o algoritmo *k-means*.
# Argumentos: nenhum
# Retorno: nenhum  

mainKMeans:  
    # POR IMPLEMENTAR (2a parte)
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    #1. cleanScreen
    jal  ra, cleanScreen
    
    #2. initializeCentroids
    jal  ra, initializeCentroids
    
    lw   s0, L  #s0 --> iterador (vem do L que ? o numero de execu??es do c?digo)
mainLoop:
    jal  ra, cleanScreen
    
    #3. attributeCluster
    jal  ra, attributeCluster
    
    #4. calculateCentroids
    jal  ra, calculateCentroids
    
    #3. printClusters
    jal  ra, printClusters
    
    #5. printCentroids
    jal   ra, printCentroids
    
    addi s0, s0, -1
    bnez s0, mainLoop 
    #end loop
    
    #6. Termina
    #la a0, messageEndMainKmeans
    li a7, printString
    ecall
    
    # Mensagem de fim de execucao
    lw    ra, 0(sp)
    addi  sp, sp, 4
    jr ra
    
#vers�o 2.0