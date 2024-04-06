-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom: Roger Daniel-Stephane                        Votre DA: 2255500
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
DESC OUTILS_OUTIL;
DESC outils_emprunt;
DESC outils_usager;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
Select concat(prenom,' ',nom_famille)
From outils_usager

-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2

Select ville
from outils_usager
order by ville asc;

-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
Select *
from outils_outil
order by nom asc;

-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
Select num_emprunt,date_retour
From outils_emprunt
where date_retour IS NULL;

-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3

Select num_emprunt,date_emprunt
from outils_emprunt 
where date_emprunt < '2014-01-01'


-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
Select nom,code_outil
From outils_outil
where caracteristiques like '%j%';

-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2

Select nom,code_outil,fabricant
From outils_outil
where fabricant = 'Stanley';

-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2

Select nom,fabricant
From outils_outil
where annee between 2006 and 2008;

-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3

Select code_outil, nom
From outils_outil
where caracteristiques NOT LIKE '%20 volt%';


-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2

Select count(*)
From outils_outil
where fabricant not like 'Makita';

-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
Select u.nom_famille || ' ' || u.prenom as "nom complet", e.num_emprunt, e.date_retour - e.date_emprunt as "durée de l'emprunt",
o.prix
From outils_usager u
Join outils_emprunt e on u.num_usager = e.num_usager
Join outils_outil o on e.code_outil = o.code_outil
Where u.ville in ('vancouver', 'regina')
And e.date_retour is null;


-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4

select o.nom, e.code_outil
from outils_emprunt e
join outils_outil o on e.code_outil = o.code_outil
where e.date_retour is null;

-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3

select nom_famille, courriel
from outils_usager
where num_usager not in (select distinct num_usager from outils_emprunt);

-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4

select o.code_outil, o.prix
from outils_outil o
left outer join outils_emprunt e on o.code_outil = e.code_outil
where e.code_outil is null;

-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4

select o.nom, coalesce(o.prix, avg_price.avg_price) as "prix"
from outils_outil o
join (select avg(prix) as avg_price from outils_outil) avg_price on 1=1
where o.fabricant = 'makita'
and coalesce(o.prix, avg_price.avg_price) > avg_price.avg_price;

-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4

select u.nom_famille, u.prenom, u.adresse, o.nom, o.code_outil
from outils_usager u
join outils_emprunt e on u.num_usager = e.num_usager
join outils_outil o on e.code_outil = o.code_outil
where e.date_emprunt > to_date('2014-01-01', 'yyyy-mm-dd')
order by u.nom_famille;

-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4

select o.nom, o.prix
from outils_outil o
join outils_emprunt e on o.code_outil = e.code_outil
group by o.nom, o.prix
having count(*) > 1;

-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6

--  Une jointure

--  IN

--  EXISTS

select u.nom_famille, u.adresse, u.ville
from outils_usager u
where exists (select 1 from outils_emprunt e where e.num_usager = u.num_usager);


-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3

SELECT FABRICANT, AVG(PRIX) AS "Moyenne du prix"
FROM OUTILS_OUTIL
GROUP BY FABRICANT;

-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4

select u.ville, sum(o.prix) as "somme des prix des outils empruntés"
from outils_usager u
join outils_emprunt e on u.num_usager = e.num_usager
join outils_outil o on e.code_outil = o.code_outil
group by u.ville
order by "somme des prix des outils empruntés" desc;

-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2

INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, FABRICANT, CARACTERISTIQUES, ANNEE, PRIX)
VALUES ('NOUVEL_OUTIL', 'Nom de l\'outil', 'Fabricant', 'Caractéristiques de l\'outil', 2024, 100);


-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2

INSERT INTO OUTILS_OUTIL (NOM, CODE_OUTIL, ANNEE)
VALUES ('Nouvel outil', 'NOUVEL_OUTIL_2', 2024);


-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2

DELETE FROM OUTILS_OUTIL WHERE CODE_OUTIL IN ('NOUVEL_OUTIL', 'NOUVEL_OUTIL_2');


-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2

UPDATE OUTILS_USAGER SET NOM_FAMILLE = UPPER(NOM_FAMILLE);

