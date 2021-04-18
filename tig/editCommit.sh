shortCommit=${1:0:7}
GIT_SEQUENCE_EDITOR="sed -i -re 's/^pick\ $shortCommit/e\ $shortCommit/'" git rebase -i $shortCommit^
