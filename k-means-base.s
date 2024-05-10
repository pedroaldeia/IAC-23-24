#
# IAC 2023/2024 k-means
# 
# Grupo:27/21/24?
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



# Valores de centroids e k a usar na 1a parte do projeto:
centroids:   .word 0,0
k:           .word 1

# Valores de centroids, k e L a usar na 2a parte do prejeto:
#centroids:   .word 0,0, 10,0, 0,10
#k:           .word 3
#L:           .word 10

# Abaixo devem ser declarados o vetor clusters (2a parte) e outras estruturas de dados
# que o grupo considere necessarias para a solucao:
#clusters:    




#Definicoes de cores a usar no projeto 

colors:      .word 0xff0000, 0x00ff00, 0x0000ff  # Cores dos pontos do cluster 0, 1, 2, etc.

.equ         black      0
.equ         white      0xffffff




# Codigo
 
.text
    # Chama funcao principal da 1a parte do projeto
    jal mainSingleCluster

    # Descomentar na 2a parte do projeto:
    #jal mainKMeans
    
    #Termina o programa (chamando chamada sistema)
    li a7, 10
    ecall


### printPoint
# Pinta o ponto (x,y) na LED matrix com a cor passada por argumento
# Nota: a implementacao desta funcao ja' e' fornecida pelos docentes
# E' uma funcao auxiliar que deve ser chamada pelas funcoes seguintes que pintam a LED matrix.
# Não altera registos temporários.
# Argumentos:
# a0: x
# a1: y
# a2: cor

printPoint:
    li a3, LED_MATRIX_0_HEIGHT
    sub a1, a3, a1
    addi a1, a1, -1
    li a3, LED_MATRIX_0_WIDTH
    mul a3, a3, a1
    add a3, a3, a0
    slli a3, a3, 2
    li a0, LED_MATRIX_0_BASE
    add a3, a3, a0   # addr
    sw a2, 0(a3)
    jr ra
    

### cleanScreen
# Limpa todos os pontos do ecrã
# Argumentos: nenhum
# Retorno: nenhum
# POR IMPLEMENTAR (1a parte)
cleanScreen:
    li t1, LED_MATRIX_0_HEIGHT
    li t2, LED_MATRIX_0_WIDTH
    mul t1, t2, t1 # t1 - num leds
    slli t1, t1, 2 # t1 - num leds * 4
    li t2, LED_MATRIX_0_BASE  # => 1º addr
    add t1, t1, t2  # t1 - num leds * 4 + Base => ult addr
    
cSLoop:
    beq t2,t1, cSOut  
    sw x0, 0(t2)
    addi t2, t2, 4
    j cSLoop
cSOut:
    jr ra

    
### printClusters
# Pinta os agrupamentos na LED matrix com a cor correspondente.
# Argumentos: nenhum
# Retorno: nenhum

printClusters:
    # IMPLEMENTADO (1a parte) - POR IMPLEMENTAR (2a parte)
    la   t0, n_points    #t0-> n_points
    la   t1, points      #t1-> vetor points
    #la   t3, clusters    #t3-> vetor clusters
    #la   t4, colors      #t4-> vetor das cores
    lw   t0, 0(t0)
    #salvaguardar os argumentos anteriores:
    addi sp, sp, -16
    sw   ra, 0(sp)
    sw   a0, 4(sp)
    sw   a1, 8(sp)
    sw   a2, 12(sp)
printLoop:
    beq  t0, x0, endLoop #se ja não houverem pontos para dar print
    addi t0, t0, -1 
    lw   a0, 0(t1)       #vai buscar o x e y
    lw   a1, 4(t1)  
    li   a2, 0xffffff ## <--remover depois
    #lw   t5, 0(t3)       #vai buscar o numero do cluster do ponto
    #slli t5, t5, 2
    #addi t4, t5, t4      #calcula o endereço da cor do cluster
    #lw   a2, 0(t4)       #vai buscar a cor
    #addi t3, t3, 4
    addi t1, t1, 8        #passa para o proximo ponto
    jal  ra, printPoint   #pinta o ponto (anterior) no led
    j    printLoop
endLoop:
    #vai buscar os valores de antes
    lw   ra, 0(sp)
    lw   a0, 4(sp)
    lw   a1, 8(sp)
    lw   a2, 12(sp)
    addi sp, sp, 16
    jr ra                 #volta para o endereço anterior

### printCentroids
# Pinta os centroides na LED matrix
# Nota: deve ser usada a cor preta (black) para todos os centroides
# Argumentos: nenhum
# Retorno: nenhum

printCentroids:
    # IMPLEMENTADO (1a parte) - POR IMPLEMENTAR (2a parte)
    la t0, k  # t0 = &k
    lw t0, 0(t0) # t0 = *t0
    la t1, centroids  # first item addr, centroids
    slli t0, t0, 3 # t0 = t0 * 8  [k*4*2]
    add t0, t1, t0  # t0 = [centroids_out_of_bounds]
prtCenLoop:
    beq t1, t0, prtCenOut  # se t1 == t0 [addr_centroid == centroids_out_of_bounds]

    addi sp, sp, -4
    sw ra, 0(sp)
    
    lw a0, 0(t1)
    lw a1, 4(t1)
    li a2, white  # depois ver como mudar dependendo das situações
    jal printPoint  # print(t1.x, t1.y, white) ; t1 (addr_centroid)
    lw ra, 0(sp)
    addi t1, t1, 8

    j prtCenLoop
prtCenOut:
    jr ra
    

### calculateCentroids
# Calcula os k centroides, a partir da distribuicao atual de pontos associados a cada agrupamento (cluster)
# Argumentos: nenhum
# Retorno: nenhum

calculateCentroids:
    # POR IMPLEMENTAR (1a e 2a parte)
    
    jr ra


### mainSingleCluster
# Funcao principal da 1a parte do projeto.
# Argumentos: nenhum
# Retorno: nenhum

mainSingleCluster:
    addi sp, sp, -4
    #sw ra, 0(sp)
    #jal printClusters
    jal printCentroids
    #1. Coloca k=1 (caso nao esteja a 1)
    # POR IMPLEMENTAR (1a parte)

    #2. cleanScreen
    # POR IMPLEMENTAR (1a parte)

    #3. printClusters
    # POR IMPLEMENTAR (1a parte)

    #4. calculateCentroids
    # POR IMPLEMENTAR (1a parte)

    #5. printCentroids
    # POR IMPLEMENTAR (1a parte)

    #6. Termina

    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra



### manhattanDistance
# Calcula a distancia de Manhattan entre (x0,y0) e (x1,y1)
# Argumentos:
# a0, a1: x0, y0
# a2, a3: x1, y1
# Retorno:
# a0: distance

manhattanDistance:
    # POR IMPLEMENTAR (2a parte)
    jr ra


### nearestCluster
# Determina o centroide mais perto de um dado ponto (x,y).
# Argumentos:
# a0, a1: (x, y) point
# Retorno:
# a0: cluster index

nearestCluster:
    # POR IMPLEMENTAR (2a parte)
    jr ra


### mainKMeans
# Executa o algoritmo *k-means*.
# Argumentos: nenhum
# Retorno: nenhum

mainKMeans:  
    # POR IMPLEMENTAR (2a parte)
    jr ra


# TESTES
testeClean:
    li a0, 1
    li a1, 1
    li a2, 0x00FF0000
    addi sp, sp -4
    sw ra, 0(sp)
    jal printPoint
    
    li a0, 0
    li a1, 0x18
    li a2, 0x0000FFFF
    jal printPoint
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra