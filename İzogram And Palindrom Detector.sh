#!bin/bash

dosya=$1
#İzogram kelime sayısını tutacak bir sayac.
izogram_sayac=0
#Palidrom kelime sayısını tutacak bir sayac.
palindrom_sayac=0
#En uzun izogram kelimeyi tutacak bir değişken.
enuzuun_izogram=""
#En uzun palidrom kelimeyi tutacak bir değişken.
enuzun_palindrom=""

function izogrambul() {
#Dosyanın satırlarını oku.
while read -r satir; 
do
	#Satırları kelimelere ayır.
	kelimeler=($satir)
   	#Her kelime için döngü.
	for kelime in "${kelimeler[@]}"; do
    		#İzogram kelime olup olmadığını kontrol et.
		#Döngünün her adımında, kelime harflerinden birinin kelime içinde başka bir yerde tekrar edip etmediği kontrol edilir.
		#Eğer tekrar ediyorsa, izogram_durumu değişkeni false yapılır ve döngüden çıkılır.
		#* joker karakteriyle birlikte kullanıldığında, "${kelime:i+1}" ifadesinin herhangi bir kısmında "${kelime:i:1}" ifadesinin geçtiği tespit edilirse, koşul doğru olur.
		izogram_durumu=true
		for ((i=0; i<${#kelime}; i++)); do
			if [[ "${kelime:i+1}" == *"${kelime:i:1}"* ]]; then
        			izogram_durumu=false
				break
			fi
		done

    #İzogram kelime ise sayısını artır ve en uzun izogram kelimeyi güncelle.
		if $izogram_durumu; then
      			izogram_sayac=$((izogram_sayac+1))
      			if [[ ${#kelime} -gt ${#enuzun_izogram} ]]; then
        			enuzun_izogram=$kelime
      			fi
    		fi
	done
done < "$dosya"

#İzogram kelime sayısını ve en uzun izogram kelimeyi ekrana yazdır.
echo "İzogram kelime sayısı: $izogram_sayac"
echo "En uzun izogram kelime: $enuzun_izogram"
}
function palindrombul() {
while read -r satir; do
  	#Dosya içerisindeki tüm satırları kelime kelime ayırır.
	kelimeler=($satir)

  	#Her bir kelime için palindrom mu ? döngüsü. 
	for kelime in "${kelimeler[@]}"; do
    		palindrom_durumu=true
		#Bu döngüde i değişkeni 0 dan başlayıp kelimenin harf sayısının yarısı miktarı kadar ilerler,
		# (baştan 1. ile sondan 1. harfi sonrasında baştan 2. ve sondan 2. harfi kıyaslar...),
		#eğer harflerden en az birinde bile uyumsuzluk olursa paldrom durumu false olur ve döngü kırılır,
		#eğer palindrom durumu true ise alttaki if bloğuna girilir.
    		for ((i=0; i<${#kelime}/2; i++)); do
      			if [[ "${kelime:i:1}" != "${kelime:${#kelime}-i-1:1}" ]]; then
        			palindrom_durumu=false
        			break
      			fi
		done

		#Palindrom durumu true ise palidrom_sayac sayısını artır ve en uzun palindrom kelimeyi kontrol et, 
		#eğer yeni palindrom kelime önceki paindrom kelimeden uzun ise,
		#yeni palinrom kelimeyi, en uzun palindrom kelime olarak güncelle.
		if $palindrom_durumu; then
      			palindrom_sayac=$((palindrom_sayac+1))
      			if [[ ${#kelime} -gt ${#enuzun_palindrom} ]]; then
        			enuzun_palindrom=$kelime
      			fi
    		fi
	done
done < "$dosya"

#Palindrom kelime sayısını ve en uzun palindrom kelimeyi ekrana yazdır.
echo "Palindrom kelime sayısı: $palindrom_sayac"
echo "En uzun palindrom kelime: $enuzun_palindrom"
}
#Eğer argüman sayısı 1'den farklı ise uyarı ver ve uygulamayı kapat.
if [[ $# -ne 1 ]]; 
then
        echo "Lütfen argüman olarak sadece bir dosya adı girin!"
        exit 1
fi

#Eğer dosya bulunamaz ise uyarı ver ve uygulamayı kapat.
if [[ ! -f $dosya ]]; 
then
        echo "Dosya bulunamadı!"
        exit 1
fi

#Dosya içindeki tüm kelimelerin sayısını yazdır.
toplamkelime=$(wc -w < $dosya)
echo "Toplam kelime sayısı: $toplamkelime"

#Eğer if yapıları uygulamayı kapatmaz ise alt programları çalışır.
izogrambul "$dosya"
palindrombul "$dosya"
