summary(wine.trans)
str(wine.trans)
dim(wine.trans)

describe(wine.trans)

# Response

table(wine.trans$qual) # very unbalanced: ~1400 poor, 200 good

# boxplot response
response_boxplot <- wine.trans %>%
mutate(qual = factor(qual, labels=c("poor", "good"))) %>%
count(qual) %>% ungroup() %>% mutate(percentage = prop.table(n) * 100) %>%  ggplot(aes(x = qual, y = percentage, fill = qual)) + ylim(0, 100) + geom_bar(stat = "identity", position = "dodge") + geom_text(aes(y = percentage + 5, label = paste0(round(percentage, 2), "%")), position = position_dodge(width = 0.9), size = 3) + xlab("Quality") + ylab("Percentage of response") + viridis::scale_fill_viridis(discrete = TRUE, guide=FALSE)


# Boxplot explanatory variables

pal <- viridis(2)

boxplot_data <- wine.trans %>%
    mutate(qual = factor(qual, labels=c("poor", "good"))) %>%
    melt(id.vars="qual",variable.name="explanatory",value.name="value")

explanatory_boxplot <- ggplot(boxplot_data,aes(x=explanatory,y=log10(value+1))) +
    geom_boxplot(aes(fill=qual)) +
    theme(axis.text.x = element_text(angle=45,vjust=0.5,hjust=1)) +
    scale_fill_viridis(discrete = T,alpha = 0.7) +
    ylab("Log-transformed value") + xlab("Variable")


# Correlations

library(ggcorrplot)
correlations_plot <- ggcorrplot(cor(wine.trans[,-12],method = "spearman"), p.mat = cor_pmat(wine.trans[,-12]), hc.order = TRUE, type = "lower", method="circle") + scale_fill_viridis_c()

## PCA


library(FactoMineR)
library(pca3d)
library(htmltools)

pca2 <-prcomp(wine.trans[-12],  scale.=TRUE)
pca3d(pca2, biplot=T, group = qual, palette = pal, axes.color = pal[3], shape="sphere", radius = 0.4)

writeWebGL(dir=file.path("webGL"), filename="pca.html", width=1000, height=500)
