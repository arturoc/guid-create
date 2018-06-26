#!/bin/sh

upload_files() {
  	echo "Travis branch: " $TRAVIS_BRANCH "..."
  	if [ $TRAVIS_BRANCH == "auto" ]; then
		echo "Will merge to master..."	
		git clone https://${GH_TOKEN}@github.com/kurtlawrence/guid-create.git 
		cd guid-create/
		git remote -v
		git branch -a
		git merge origin/auto
		if [[ $? != 0 ]]; then
			echo "Merge failed..."
			exit 1
		else
			echo "Merge succeeded..."
			git commit --amend -m "Passed travis build: $TRAVIS_BUILD_NUMBER"
			cargo login $CARGO_LOGIN
			cargo publish
			if [[ $? != 0 ]]; then
				echo "Publish failed..."
				exit 1
			else
				echo "Publish succeeded..."
				git push
			fi
		fi
	else
		echo "Not 'auto' branch, will not merge or publish..."
	fi  
}

upload_files