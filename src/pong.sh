#!/bin/bash

##################################################
#          Pong shell game by ByteBox            #     
##################################################

############################################################################################################################################
# variables

BACKGROUND_CHARACTER='.'
PADDLE_CHARACTER="#"
BALL_CHARACTER="@"
SCREEN_WIDTH=$(tput cols)
SCREEN_HEIGHT=$(tput lines)
PADDLE_HEIGHT=$((SCREEN_HEIGHT / 3))
PADDLE_WIDTH=$((SCREEN_WIDTH / 25))
BALL_X_POS=$((SCREEN_WIDTH / 2))
BALL_Y_POS=$((SCREEN_HEIGHT / 2))
BALL_X_MOV=1
BALL_Y_MOV=0
PADDLE_1_HEIGHT=$((SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2 + 2))
PADDLE_2_HEIGHT=$((SCREEN_HEIGHT / 2 - PADDLE_HEIGHT / 2 + 2))
BACKGROUND_COLOR=90
PADDLE_1_COLOR=91
PADDLE_2_COLOR=94
BALL_COLOR=96

############################################################################################################################################
# functions

# function for resetting terminal color
reset_color () {
	printf "\033[0m"
}

print_color() {
	printf "\033[0;%dm" "$1"
}

# function for filling background with background character
fill_background () {
	printf "\033[0;0f"			# ANSI sequence to move cursor to top left corner
	print_color $BACKGROUND_COLOR
	for (( y=1; y<=SCREEN_HEIGHT; ++y)); do
		for (( x=1; x<=SCREEN_WIDTH; ++x)); do
			# put background character
			printf "%c" "$BACKGROUND_CHARACTER"
		done
		if  [ $y -lt $SCREEN_HEIGHT ]; then
			printf "\n"
		fi
	done	
	reset_color
}

# function for processing the given input
input_control () {
	if [ "$REPLY" = "s" ] && [ $PADDLE_1_HEIGHT -le $((SCREEN_HEIGHT - PADDLE_HEIGHT)) ]; then
		 (( PADDLE_1_HEIGHT += 1 ))
	fi
	if [ "$REPLY" = "w" ] && [ $PADDLE_1_HEIGHT -ge 2 ]; then
		 (( PADDLE_1_HEIGHT -= 1 ))
	fi
	if [ "$REPLY" = "e" ] && [ $PADDLE_2_HEIGHT -ge 2 ]; then
		 (( PADDLE_2_HEIGHT -= 1 ))
	fi
	if [ "$REPLY" = "d" ] && [ $PADDLE_2_HEIGHT -le $((SCREEN_HEIGHT - PADDLE_HEIGHT)) ]; then
		 (( PADDLE_2_HEIGHT += 1 ))
	fi

}

# function for updating the direction the ball is going in
update_ball_direction () {
	if [ $BALL_X_POS -ge $(( SCREEN_WIDTH - PADDLE_WIDTH )) ] && [ $BALL_Y_POS -ge $PADDLE_2_HEIGHT ] && [ $BALL_Y_POS -le $(( PADDLE_2_HEIGHT + PADDLE_HEIGHT )) ]; then
		BALL_X_MOV=0
	fi
	if [ $BALL_X_POS -le $(( 1 + PADDLE_WIDTH )) ] && [ $BALL_Y_POS -ge $PADDLE_1_HEIGHT ] && [ $BALL_Y_POS -le $(( PADDLE_1_HEIGHT + PADDLE_HEIGHT )) ]; then
		BALL_X_MOV=1
	fi

	if [ $BALL_Y_POS -ge $SCREEN_HEIGHT ]; then 
		BALL_Y_MOV=0
	elif [ $BALL_Y_POS -le 1 ]; then 
		BALL_Y_MOV=1
	fi
}

# function for updating the ball's position
update_ball_position () {
	if [ $BALL_X_MOV -eq 0 ]; then
		(( BALL_X_POS -= 1 ))
	elif [ $BALL_X_MOV -eq 1 ]; then
		(( BALL_X_POS += 1 ))
	fi
	
	if [ $BALL_Y_MOV -eq 0 ]; then
		(( BALL_Y_POS -= 1 ))
	elif [ $BALL_Y_MOV -eq 1 ]; then
		(( BALL_Y_POS += 1 ))
	fi
}

# function for moving the terminal cursor and printing the ball
print_ball () {
	print_color $2
	printf "\033[%d;%df" "$BALL_Y_POS" "$BALL_X_POS" 
	printf "%c" "$1"
	reset_color
}

# function for moving the terminal cursor and printing the paddles
print_paddles () {
	printf "\033[%d;0f" "$PADDLE_1_HEIGHT"
	
	print_color $2
	for (( y=1; y<=PADDLE_HEIGHT; ++y)); do
		for (( x=1; x<=PADDLE_WIDTH; ++x)); do
			# put paddle character
			printf "%c" "$1"
		done
		if  [ $y -lt $PADDLE_HEIGHT ]; then
			printf "\n"
		fi
	done
	
	print_color $3
	printf "\033[%d;%df" "$PADDLE_2_HEIGHT" "$((SCREEN_WIDTH + 1 - PADDLE_WIDTH))"
	for (( y=1; y<=PADDLE_HEIGHT; ++y)); do
		for (( x=1; x<=PADDLE_WIDTH; ++x)); do
			# put paddle character
			printf "%c" "$1"
		done
		printf "\033[%d;%df" "$((y + PADDLE_2_HEIGHT))" "$((SCREEN_WIDTH + 1 - PADDLE_WIDTH))"
	done
	reset_color
}

game_init () {
	clear
	stty -icanon -echo
	fill_background
}

############################################################################################################################################
# main game loop

game_init

# game loop
while :
do
	print_ball $BALL_CHARACTER $BALL_COLOR
	print_paddles $PADDLE_CHARACTER $PADDLE_1_COLOR $PADDLE_2_COLOR

	# check if ball is out of bounds
	if [ $BALL_X_POS -ge $SCREEN_WIDTH ]; then 
		break
	fi
	if [ $BALL_X_POS -le 1 ]; then 
		break
	fi
	
	# read one character
	read -n1 -t 0.1;
	
	print_ball $BACKGROUND_CHARACTER $BACKGROUND_COLOR
	print_paddles $BACKGROUND_CHARACTER $BACKGROUND_COLOR $BACKGROUND_COLOR
	
	input_control
	update_ball_direction
	update_ball_position
done

printf "\033[%d;%df" "$((SCREEN_HEIGHT / 2 + 1))" "$((SCREEN_WIDTH / 2 - 5))"
printf "Game over!\n" 
printf "\033[%d;%d0f" "$((SCREEN_HEIGHT))"
stty icanon echo
############################################################################################################################################
