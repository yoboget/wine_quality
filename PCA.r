
library(FactoMineR)
library(pca3d)
library(rgl)

pca2 <-prcomp(wine.trans[-12],  scale.=TRUE)
pca3d(pca2, biplot=T, group = wine.trans$qual, palette = c(pal[1],pal[8]), axes.color = pal[3], shape="sphere",  radius = 0.4)
pcascene <- scene3d()

pcargl <- rglwidget(x=pcascene, width=900, height=600)
