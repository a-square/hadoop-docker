if [[ $(uname) -eq 'Darwin' ]]
then
	DOCKER='docker'
	TIME='time'
else
	DOCKER='sudo docker'
	TIME='/usr/bin/time -f "real  %e"'
fi
