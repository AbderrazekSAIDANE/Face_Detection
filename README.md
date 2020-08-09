# Face_Detection

Ceci est un algorithme de detection de visage humain bassé sur la détection de pixel ayant une couleur proche de la peau humaine. 

De nos jours toutes les images capturées par un appareil son en mode RVB par défaut,
nous allons les convertir en mode YUV pour segmenter l'image en  utilisant que la couche U, deuxième couche.

D'après une étude, les pixels de cette couche ayant une valeur entre 30 et 70 ont une probabilité élevée de représenter une peau humaine. Le travaille consiste à donner à ces pixels une couleur blanche et le reste une couleur noir. Après cette étape, on convertit l'image résultant de la précedente étape en image binaire afin d'aporter d'autres traitements necessaires, érosion, dilatation.

L'étape qui suit est crusiale car on labélise les pixels de l'image puis on les regroupes, de cette manière on peut créer des régions dans l'image et calculer la surface de chaque région. 

D'après une étude complémentaire à la première, si une région de ces régions a plus de 26% de la surface totale de l'image alors la région est concidérée et probablement un visage humain.  

