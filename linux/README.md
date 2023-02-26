
```
for var in $(grep "werf" -r -l | awk -F"/" '{print $2}' | sort | uniq)
do
git --git-dir=./$var/.git log -- werf.yaml | grep Date ; echo $var
done
```
