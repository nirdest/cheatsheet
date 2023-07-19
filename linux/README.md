
```
for var in $(grep "werf" -r -l | awk -F"/" '{print $2}' | sort | uniq)
do
git --git-dir=./$var/.git log -- werf.yaml | grep Date ; echo $var
done
```


```
cat /var/log/nginx/access.log | awk -F "," '{print $4 " - " $5 " - " $21 " - " $22 " - " $3}' \
| grep request_time \
| awk -F '"' '{gsub(/\./, ",", $12); gsub(/\/Jun\//, ".06.", $20); gsub(/ +\+0300/, "", $20); \
gsub(/ +\HTTP\/1.1/, "", $4); split($20, datetime, /[:]/); \
print " | " $4 " | " $8 " | " $12 " | " $16 "| "  datetime[1] " | " datetime[2] ":" datetime[3] ":" datetime[4] }' \
| grep 'sounds\|firmwares' | grep -v " /sounds/ " | grep -v " /firmwares/ " \
| grep -v " /firmwares/?location= " | grep -v " /sounds/?location= " | grep firmwares >> gg3.txt
```

```
while true; do curl -s -o /dev/null -w "%{http_code} - %{time_total}s/n” https://ya.ru/  ; done
```
