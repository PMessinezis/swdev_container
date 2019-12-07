setup: Dockerfile
	docker ps | grep mySWDev && docker stop mySWDev || echo mySWDev not running
	docker ps -all | grep mySWDev && docker rm mySWDev || echo mySWDev does not exist
	docker build . -t swdev 
#	docker run --rm --name mySWDev --hostname swdev \
	       -v ~/workspace:/workspace \
		   -v ~/.bash_aliases:/home/coder/.bash_aliases  \
		   -v ~/.bashrc:/home/coder/.bashrc  \
		   -v ~/.profile:/home/coder/.profile  \
		   -v ~/bin:/home/coder/bin  \
		   -v ~/.ssh:/home/coder/.ssh  \
		   -v ~/.gitconfig:/home/coder/.gitconfig  \
		   -d swdev
	docker ps
