cp -r _site/ travis_site/_site/
echo 'Copy _site build dir into travis_site/ dir'
git add .
echo 'Add all files'
git commit -m "Travis copy of _site/ dir into travis_site/_site/ dir"
echo 'Commit all changes'
git push -u origin master
echo 'Push to Master branch on GitHub'
