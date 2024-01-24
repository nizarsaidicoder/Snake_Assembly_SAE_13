################################################################################################################
################################################################################################################
################################################################################################################
################################################################################################################
######################## PROJECT SNAKE SAE 1.3 : HAGGUI NESRINE | SAIDI NIZAR #################################
################################################################################################################
################################################################################################################
################################################################################################################
################################################################################################################
#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas nécessaire de les modifier.!!!

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4

PSLoop:
bge $s1 $s0 endPSLoop
  lw $a0 colors + green
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
or $t0 0x2
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 115
beq $t0 $t1 GIhaut
li $t1 122
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

#jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
li $a0 200
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur
space: .asciiz "\n"
gameOverDisplayCordX: .word 2,2,2,2,2,2, 3,3,3,3,3,3,3,3 4,4,4,4 ,6,6,6,6,6,6,6,6,6,6,7,7,8,8,9,9,9,9,9,9,9,9,9,9,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,13,13,13,13,13,13 
gameOverDisplayCordY: .word 1,8,9,10,11,12,1,2,3,4,5,8,10,12,1,8,10,12,1,2,3,4,5,8,9,10,11,12,3,8,3,8,1,2,3,4,5,8,9,10,11,12,1,2,3,4,5,8,9,10,11,12,1,3,5,8,12,1,3,5,9,10,11
gameOverText: .asciiz "Game Over, ton score est :  \n" 
.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire un demi-tour 
#                 (se retourner en un seul tour. Par exemple passer de la 
#                 direction droite à gauche directement est impossible (un 
#                 serpent n'est pas une chouette)
################################################################################

majDirection:

    lw $t1, snakeDir     # Charge la valeur du snakeDir dans le registre $t1 
    
	beq $a0, 0, setUp     # Si la valeur du $a0 = 0, on change la direction vers le haut 
	beq $a0, 1, setRight  # Si la valeur du $a0 = 1, on change la direction vers la droite
	beq $a0, 2, setDown   # Si la valeur du $a0 = 2, on change la direction vers le bas
	beq $a0, 3, setLeft   # Si la valeur du $a0 = 3, on change la direction vers la gauche
	beq $a0, 4, Exit      # Si la valeur du $a0 = 4, On fait rien
	j Exit

#Change la direction vers le haut
setUp:
    li $t0, 0
    li $t2, 2
    beq $t1, $t2, Exit
    sw $t0, snakeDir
    j Exit

# Changer la direction actuelle vers le bas
setDown:
    li $t0, 2
    beq $0, $t1, Exit
    sw $t0, snakeDir
    j Exit

# Changer la direction actuelle vers la droite
setRight:
    li $t0, 1
    li $t2, 3
    beq $t2, $t1, Exit
    sw $t0, snakeDir
    j Exit

# Changer la direction actuelle vers la gauche
setLeft:
    li $t0, 3
    li $t2, 1
    beq $t2, $t1, Exit
    sw $t0, snakeDir
    j Exit


############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:

    addi $sp, $sp, -4  # Alloue de l'espace sur la pile
    sw $ra, 0($sp)     # Sauvegarde l'adresse de retour

    jal moveSnake      # Apelle la fonction moveSnake qui Avance le snake
    jal checkCandy     # Apelle la fonction checkCandy pour vérifier s'il le snake a mangé une bonbon

    lw $ra, 0($sp)     # Restaure l'adresse de retour
    addi $sp, $sp, 4   # Libere l'espace sur la pile
    j Exit


moveSnake:
    lw $t0, snakeDir         # Charge la direction du serpent
    lw $t1, snakePosX        # Charge la position actuelle en X de la tête du serpent
    lw $t2, snakePosY        # Charge la position actuelle en Y de la tête du serpent
    lw $s0, tailleSnake      # Charge la taille du serpent

    # Compare la direction du serpent et avance le snake en se basant sur la direction
    beq $t0, 0, moveSnakeUp     # Si la direction est 0, saute à moveSnakeUp
    beq $t0, 2, moveSnakeDown   # Si la direction est 2, saute à moveSnakeDown
    beq $t0, 1, moveSnakeRight  # Si la direction est 1, saute à moveSnakeRight
    beq $t0, 3, moveSnakeLeft   # Si la direction est 3, saute à moveSnakeLeft
	
    moveSnakeUp:
        addi $t1, $t1, 1           # Déplace vers le haut en décrémentant Y
        j updateMove               

    moveSnakeDown:
        addi $t1, $t1, -1          # Déplace vers le bas en incrémentant Y
        j updateMove               

    moveSnakeRight:
        addi $t2, $t2, 1           # Déplace vers la droite en incrémentant X
        j updateMove               

    moveSnakeLeft:
        addi $t2, $t2, -1          # Déplace vers la gauche en décrémentant X
        j updateMove


    ##################  Mise à jour de tout les pièces de la queue du serpent  ####################
    updateMove:
        sll $s0, $s0, 2  # Multiplie $s0 par 4 pour obtenir l'indice correct
        updateMoveLoop:
        beqz $s0, endUpdateMoveLoop  # Si $s0 = 0, saute à endUpdateMoveLoop
        subu $t3, $s0, 4             # Décrémente $s0 par 4 pour obtenir l'indice snakePos[i-1]
        lw $t4, snakePosX($t3)       # Charge la position en X de la pièce du serpent précédente
        lw $t5, snakePosY($t3)       # Charge la position en Y de la pièce du serpent précédente
        sw $t4, snakePosX($s0)       # Sauvegarde la nouvelle position en X de la pièce de la queue du serpent
        sw $t5, snakePosY($s0)       # Sauvegarde la nouvelle position en Y de la pièce de la queue du serpent
        subu $s0, $s0, 4             # Décrémente $s0 par 4
        j updateMoveLoop

    ##################  Mise à jour de la tête du serpent  ####################
    endUpdateMoveLoop:
    sw $t1, snakePosX     # Sauvegarde la nouvelle position en X de la tête du serpent
    sw $t2, snakePosY     # Sauvegarde la nouvelle position en Y de la tête du serpent
    j Exit


checkCandy: # Vérifie si les coordonnees X du serpent sont les mêmes que celles du bonbon
    li $s3, 0            
    lw $t0, candy               # Charge la position X du bonbon depuis la mémoire dans $t0
    lw $s0, snakePosX($s3)      # Charge la position X de la tête du serpent dans $s0
    beq $t0, $s0, checkAxeY     # Si la position X du bonbon est la même que celle du snake on vérifie pour la position Y
    j Exit                      # Sinon on sort de la fonction

checkAxeY: # Vérifie si les coordonnees Y du serpent sont les mêmes que celles du bonbon
    lw $t1, candy + 4           # Charge la position Y du bonbon depuis la mémoire dans $t1
    lw $s1, snakePosY($s3)      # Charge la position Y de la tête du serpent dans $s1
    beq $t1, $s1, generateNew   # Si la position Y du bonbon est égale à celle de la tête du serpent, saute à generateNew
    j Exit                      # Sinon on sort de la fonction


generateNew:
    addi $sp, $sp, -4            # Alloue de l'espace sur la pile
    sw $ra, 0($sp)               # Sauvegarde l'adresse de retour 
     
    jal generateNewCandy
    jal generateNewObstacle
    
    lw $ra, 0($sp)        # Restaure l'adresse de retour
    addi $sp, $sp, 4      # Libère l'espace sur la pile
    j Exit              # Retourne à l'adresse de retour

#################################################################################
############################### generateNewCandy ################################
#################################################################################
generateNewCandy:
    addi $sp, $sp, -4            # Alloue de l'espace sur la pile
    sw $ra, 0($sp)               # Sauvegarde l'adresse de retour  

    ######## Incremente la taille du snake par 1 lorsqu'il mange un bonbon #######
    ###############################################################################
    lw $t7, tailleSnake
    addi $t7, $t7, 1
    sw $t7, tailleSnake
    ######################## Mise à jour du score du jeu ###########################
    subu $t7,$t7,1
    sw $t7, scoreJeu

    ###############################################################################
    ################# Ajoute une nouvelle piece au snake ##########################
    ###############################################################################
    sll $t7 $t7 2
    lw $s4, lastSnakePiece
    lw $s5, lastSnakePiece + 4
    sw $s4, snakePosX($t7) 
    sw $s5, snakePosY($t7)
    ###############################################################################
    ############### Generation d'un nouveau bonbon ################################
    jal newRandomObjectPosition  # Appelle la fonction newRandomObjectPosition
    sw $v0, candy                # Stocke la nouvelle position X du bonbon
    sw $v1, candy + 4            # Stocke la nouvelle position Y du bonbon
    
    lw $ra, 0($sp)        # Restaure l'adresse de retour
    addi $sp, $sp, 4      # Libère l'espace sur la pile
    j Exit

#################################################################################
############################### generateNewObstacle ################################
#################################################################################
generateNewObstacle:
    addi $sp, $sp, -4            # Alloue de l'espace sur la pile
    sw $ra, 0($sp)               # Sauvegarde l'adresse de retour  
    
    ######## Incremente le nombre d'obstacles par 1 lorsqu'il mange un bonbon #######
    lw $t5, numObstacles  
    addi $t5, $t5, 1      # Incrémente le nombre d'obstacles
    sw $t5, numObstacles
    
    ##############################################################################
    ############### Génération de la position de l'obstacle ######################
    ###############################################################################
    jal newRandomObjectPosition
    subu $t5, $t5, 1      # Décrémente le nombre d'obstacles
    sll $t5,$t5,2         # Multiplie $t5 par 4 pour obtenir l'indice correct
    sw $v0, obstaclesPosX($t5)          # Stocke la nouvelle position X de l'obstacle
    sw $v1, obstaclesPosY($t5)          # Stocke la nouvelle position Y de l'obstacle
    ###############################################################################
    ###############################################################################
    
    lw $ra, 0($sp)        # Restaure l'adresse de retour
    addi $sp, $sp, 4      # Libère l'espace sur la pile
    j Exit

############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou 1 sinon.
################################################################################

conditionFinJeu:
addi $sp, $sp, -4
sw $ra, 0($sp)

lw $t0, snakePosX  # Charge la position en X de la tête du serpent
lw $t1, snakePosY  # Charge la position en Y de la tête du serpent

# Verifier si la tête du serpent est dans les limites de la grille (16 x 16)
# Valeur max de la position du snakeX ou snakeY est tailleGrille - 1 (15)
lw $t2, tailleGrille
blt $t0, $zero, gameover  # Teste si la position en X de la tête du serpent est négative
bge $t0, $t2, gameover    # Teste si la position en X de la tête du serpent est supérieure ou égale à la taille de la grille
blt $t1, $zero, gameover  # Teste si la position en Y de la tête du serpent est négative
bge $t1, $t2, gameover    # Teste si la position en Y de la tête du serpent est supérieure ou égale à la taille de la grille
    
jal checkSnakeBody
bnez $v0, gameOver
jal checkObstacles
bnez $v0, gameOver


# Si le snake est dans la grille, on retourne 0
li $v0, 0

lw $ra, 0($sp)
addi $sp, $sp, 4

j Exit

################################################################################
################################# gameOver #####################################
######### Effet : Donne le signal de la fin de l'execution du
######### du jeu et affiche le score du joueur dans le terminal
gameover:
li $v0, 1
jr $ra

################################################################################
############################### checkObstacles #################################
################################################################################

checkObstacles:
   lw $s0, numObstacles # Charge le nombre d'obstacles
   sll $s0 $s0 2        # Multiplie $s0 par 4 pour obtenir l'indice correct
   li $t3, 0            # Initialise le compteur à 0
   li $v0, 0            # Initialise la valeur de retour à 0
   ObsLoop:
      bge $t3, $s0, Exit        # Si le compteur est supérieur ou égal au nombre d'obstacles, on sort de la boucle
      lw $s1, obstaclesPosX($t3) # Charge la position en X de l'obstacle actuel
      lw $s2, obstaclesPosY($t3) # Charge la position en Y de l'obstacle actuel
      bne $t0, $s1, CheckNextObstacle # Si la position en X de la tête du serpent est différente de celle de l'obstacle actuel, on passe à l'obstacle suivant
      bne $t1, $s2, CheckNextObstacle # Si la position en Y de la tête du serpent est différente de celle de l'obstacle actuel, on passe à l'obstacle suivant
      li $v0, 1           # Si la position en X et en Y de la tête du serpent est la même que celle de l'obstacle actuel, on retourne 1
      j Exit
   CheckNextObstacle:
      addi $t3, $t3, 4 # Incrémente le compteur de 4
      j ObsLoop        # Retourne au début de la boucle

################################################################################
############################### checkSnakeBody #################################
################################################################################  
checkSnakeBody:
   lw $s0, tailleSnake # Charge la taille du serpent
   sll $s0, $s0, 2     # Multiplie $s0 par 4 pour obtenir l'indice correct
   li $t3, 4           # Initialise le compteur à 4 pour commencer par la 1ère pièce de la queue
   li $v0, 0           # Initialise la valeur de retour à 0
   BodyLoop:
      bge $t3, $s0, Exit   # Si le compteur est supérieur ou égal à la taille du serpent, on sort de la boucle
      lw $s1, snakePosX($t3) # Charge la position en X de la pièce du corps actuelle
      lw $s2, snakePosY($t3) # Charge la position en Y de la pièce du corps actuelle
      bne $t0, $s1, CheckNextBodyPiece # Si la position en X de la tête du serpent est différente de celle de la pièce du corps actuelle, on passe à la pièce suivante
      bne $t1, $s2, CheckNextBodyPiece # Si la position en Y de la tête du serpent est différente de celle de la pièce du corps actuelle, on passe à la pièce suivante
      li $v0, 1          # Si la position en X et en Y de la tête du serpent est la même que celle de la pièce du corps actuelle, on retourne 1
      j Exit
   CheckNextBodyPiece:
      addi $t3, $t3, 4 # Incrémente le compteur de 4
      j BodyLoop


############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation!»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:
addi $sp, $sp, -4
sw $ra, 0($sp)
####### Reinitialise l'affichage en couleur noir #######
jal resetAffichage
####### Affiche le score du joueur dans le terminal #######
la $a0, gameOverText
li $v0, 4
syscall
lw $a0, scoreJeu
li $v0, 1
syscall

############## Affiche la fin du jeu graphiquement ########################
jal printGameOverGUI

lw $ra, 0($sp)
addi $sp, $sp, 4

j Exit


################################################################################
############################# printGameOverGUI #################################
################################################################################  
printGameOverGUI:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

li $s0 63       # Charge le nombre de pixels à colorer
sll $s0 $s0 2 
li $s1 0        # Initialise le compteur à 0

PELoop:
bge $s1 $s0 endPELoop
  lw $a0 colors + red
  lw $a1 gameOverDisplayCordY($s1)
  lw $a2 gameOverDisplayCordX($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PELoop
endPELoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

Exit:
	jr $ra    # Retourne à l'adresse de retour
