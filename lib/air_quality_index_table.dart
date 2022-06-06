const String air_quality_index_table_str = """<br>
<table style="height: 600px; width: 400px; display: table; opacity: 1;" cellspacing="1" cellpadding="5" border="1" align="center">
	<thead>
		<tr>
			<th scope="col" style="background-color: rgb(192, 192, 192); text-align: center; vertical-align: top; white-space:  width: 100px; --darkreader-inline-bgcolor: #3c4143;" data-darkreader-inline-bgcolor="">&nbsp;Kategoria</th>
			<th scope="col" style="background-color: rgb(192, 192, 192); text-align: center; --darkreader-inline-bgcolor: #3c4143;" data-darkreader-inline-bgcolor="">Informacje Zdrowotne</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td style="background-color: rgb(0, 153, 0); text-align: center; vertical-align: middle; width: 20%; --darkreader-inline-bgcolor: #007a00;" data-darkreader-inline-bgcolor=""><span style="color: rgb(255, 255, 255); --darkreader-inline-color: #e8e6e3;" data-darkreader-inline-color="">&nbsp;Bardzo dobry</span></td>
			<td style="text-align:center">Jakość powietrza bardzo dobra, zanieczyszczenie powietrza nie stanowi zagrożenia dla zdrowia, warunki bardzo sprzyjające do wszelkich aktywności na wolnym powietrzu, bez ograniczeń.</td>
		</tr>
		<tr>
			<td style="background-color: rgb(153, 255, 51); text-align: center; vertical-align: middle; --darkreader-inline-bgcolor: #6cad00;" data-darkreader-inline-bgcolor="">&nbsp;Dobry</td>
			<td style="text-align:center">Jakość powietrza zadowalająca, zanieczyszczenie powietrza powoduje brak lub niskie ryzyko zagrożenia dla zdrowia. Można przebywać na wolnym powietrzu i wykonywać dowolną aktywność.</td>
		</tr>
		<tr>
			<td style="background-color: rgb(255, 255, 0); text-align: center; vertical-align: middle; --darkreader-inline-bgcolor: #999900;" data-darkreader-inline-bgcolor="">&nbsp;Umiarkowany</td>
			<td style="text-align:center">Jakość powietrza akceptowalna. Zanieczyszczenie powietrza może stanowić zagrożenie dla zdrowia w szczególnych przypadkach. Warunki umiarkowane do aktywności na wolnym powietrzu.</td>
		</tr>
		<tr>
			<td style="background-color: rgb(255, 102, 0); text-align: center; vertical-align: middle; --darkreader-inline-bgcolor: #cc5200;" data-darkreader-inline-bgcolor="">&nbsp;Dostateczny</td>
			<td style="text-align:center">Jakość powietrza dostateczna, zanieczyszczenie powietrza stanowi zagrożenie dla zdrowia oraz może mieć negatywne skutki zdrowotne. Należy ograniczyć aktywności na wolnym powietrzu.</td>
		</tr>
		<tr>
			<td style="background-color: rgb(255, 0, 0); text-align: center; vertical-align: middle; --darkreader-inline-bgcolor: #cc0000;" data-darkreader-inline-bgcolor="">&nbsp;<span style="color: rgb(255, 255, 255); --darkreader-inline-color: #e8e6e3;" data-darkreader-inline-color="">Zły</span></td>
			<td style="text-align:center">Jakość powietrza zła, osoby chore, starsze, kobiety w ciąży oraz małe dzieci powinny unikać przebywania na wolnym powietrzu. Pozostała populacja powinna ograniczyć do minimum aktywności na wolnym powietrzu.</td>
		</tr>
		<tr>
			<td style="background-color: rgb(153, 0, 0); text-align: center; vertical-align: middle; --darkreader-inline-bgcolor: #7a0000;" data-darkreader-inline-bgcolor=""><span style="color: rgb(255, 255, 255); --darkreader-inline-color: #e8e6e3;" data-darkreader-inline-color="">&nbsp;Bardzo zły</span></td>
			<td style="text-align:center">Jakość powietrza bardzo zła, ma negatywny wpływ na zdrowie. Osoby chore, starsze, kobiety w ciąży oraz małe dzieci powinny bezwzględnie unikać przebywania na wolnym powietrzu. Pozostała populacja powinna ograniczyć przebywanie na wolnym powietrzu do niezbędnego minimum. Wszelkie aktywności fizyczne na zewnątrz są odradzane.</td>
		</tr>
	</tbody>
</table>
""";
const String pollution_str = """
                               <h3>Pył zawieszony PM10 i PM2,5</h3></br>                                  
 <p>Pył zawieszony to bardzo drobne cząstki stałe, unoszące się w powietrzu. Ze względu na swoje niewielkie rozmiary,
 pył drobny dostaje się bez problemu do dróg oddechowych, powodując zmniejszoną respirację i prowadząc do chorób układu oddechowego.
  Natomiast już pył PM1 (o średnicy poniżej 1 µm) może przedostawać się do krwioobiegu. To jeden z powodów, dla których pyły 
są uznawane za bardzo niebezpieczne dla zdrowia. Dodatkowo, w skład pyłu zazwyczaj wchodzą metale ciężkie oraz wielopierścieniowe 
węglowodory aromatyczne posiadające potwierdzone właściwości kancerogenne. Z danych EEA wynika, że w roku 2017 dzienne normy PM10,
ustalone przez UE, zostały przekroczone w 17 państwach członkowskich oraz w 6 innych państwach przekazujących dane. 
W przypadku rocznej normy pyłów PM2,5 przekroczenie odnotowano w 7 państwach członkowskich oraz w 3 innych państwach przekazujących dane.
Natomiast roczne zalecenia WHO dla PM10 zostały przekroczone na 51% stacji monitorujących, w prawie wszystkich państwach raportujących 
(oprócz Estonii, Finlandii i Irlandii).   przypadku PM2,5 roczne przekroczenia zaleceń WHO odnotowano na 69% stacji monitorujących, 
w prawie wszystkich państwach raportujących (oprócz Estonii, Finlandii i Norwegii).</p></br></br>
<h3>Pozostałe zanieczyszczenia</h3></br>
Do pozostałych szkodliwych dla człowieka zanieczyszczeń powietrza, omawianych przez EEA, należą: benzen, 
dwutlenek siarki, tlenek węgla - czad, benzo(a)piren oraz metale ciężkie w pyle PM10 (arsen (As), kadm (Cd), nikiel (Ni),
ołów (Pb) i rtęć (Hg)). EEA informuje, że zanieczyszczenie powietrza szkodzi nie tylko bezpośrednio człowiekowi, 
ale również florze i faunie. Wpływa negatywnie na stan jakości gleb i wód. Wśród najbardziej szkodliwych zanieczyszczeń powietrza 
dla świata przyrody EEA wymienia ozon, amoniak i tlenki azotu. Dla prawie wszystkich wymienionych zanieczyszczeń obserwujemy spadek
ich emisji w latach 2000-2017. Wyjątek stanowi jedynie emisja amoniaku, która za sprawą rozwoju rolnictwa od 2013 roku zaczyna
stopniowo wzrastać, ale w dalszym ciągu jest niższa niż w roku 2000.</p>""";
