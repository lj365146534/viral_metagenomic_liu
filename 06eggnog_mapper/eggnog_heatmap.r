
setwd('E:\\Ja序列分析\\宏基因组\\课题--测序\\粪便-咽拭子样本\\06eggnog_mapper')

library(pheatmap)
library(dplyr)
library(ggplot2)

# COG
# 数据导入
COG_categorys=read.table("result\\eggnog-230618\\eggnog.COG_category.raw.txt", header = TRUE, row.names = 1, sep = "\t",check.names = FALSE)

#归一化并去除含有NA的列
COG_categorys_S <- data.frame(scale(COG_categorys,center = F),check.names = F) %>% select_if(~!any(is.na(.)))

#COG_categorys = t(COG_categorys)
# Generate annotations for rows and columns
annotation_col1=read.table("result\\eggnog-230618\\COG_category_anno_col.txt", header = TRUE, row.names = 1, sep = "\t")
annotation_row1=read.table("result\\eggnog-230618\\COG_category_anno_row.txt", header = TRUE, row.names = 1, sep = "\t")


# 生成图片
#pheatmap(COG_categorys,main = "heatmap", annotation_row = annotation_col1, annotation_col = annotation_row1,show_rownames=FALSE,show_colnames=TRUE)
ph1 <- pheatmap(COG_categorys_S,main = "COG", annotation_row = annotation_row1, annotation_col = annotation_col1,show_rownames=TRUE,show_colnames=F,color = colorRampPalette(colors = c("white","red"))(100))

# 保存图片
ggsave(file = "E:\\Ja序列分析\\宏基因组\\课题--测序\\粪便-咽拭子样本\\06eggnog_mapper\\result\\eggnog-230618\\eggnog.COG_category.raw.pdf",plot = ph1, width = 30,height = 12, units = "in",limitsize = FALSE)





# CAZy by KEGG
# 数据导入
CAZy=read.table("result\\eggnog-230618\\eggnog.CAZy.raw.txt", header = TRUE, row.names = 1, sep = "\t",check.names = FALSE)

#归一化并去除含有NA的列
# CAZy_S <- data.frame(scale(CAZy),check.names = F) %>% select_if(~!any(is.na(.)))
CAZy_S2 <- data.frame(scale(CAZy,center = F),check.names = F) %>% select_if(~!any(is.na(.)))

# Generate annotations for rows and columns
annotation_col1=read.table("result\\eggnog-230618\\COG_category_anno_col.txt", header = TRUE, row.names = 1, sep = "\t")
annotation_row1=read.table("result\\eggnog-230618\\CAZy_anno_row2.txt", header = TRUE, row.names = 1, sep = "\t")

#生成图片
#CAZy_p <- pheatmap(CAZy_S,main = "CAZy", annotation_col = annotation_col1,show_rownames=TRUE,show_colnames=F,color = colorRampPalette(colors = c("blue","white","red"))(100))
#CAZy_p <- pheatmap(CAZy_S,main = "CAZy", annotation_col = annotation_col1,show_rownames=TRUE,show_colnames=F)
CAZy_p2 <- pheatmap(CAZy_S2,main = "CAZy", annotation_col = annotation_col1, annotation_row = annotation_row1,show_rownames=TRUE,show_colnames=F,color = colorRampPalette(colors = c("white","red"))(100))
# 保存图片
# ggsave(file = "E:\\Ja序列分析\\宏基因组\\课题--测序\\粪便-咽拭子样本\\06eggnog_mapper\\result\\eggnog-230618\\eggnog.CAZy.raw.pdf",plot = CAZy_p, width = 30,height = 12, units = "in",limitsize = FALSE)
ggsave(file = "E:\\Ja序列分析\\宏基因组\\课题--测序\\粪便-咽拭子样本\\06eggnog_mapper\\result\\eggnog-230618\\eggnog.CAZy.raw.pdf",plot = CAZy_p2, width = 30,height = 12, units = "in",limitsize = FALSE)




# KEGGPathway
# 数据导入
KEGGPathway=read.table("result\\eggnog-230618\\KEGG.PathwayL2.raw.txt", header = TRUE, row.names = 1, sep = "\t",check.names = FALSE)

#归一化并去除含有NA的列
KEGGPathway_S2 <- data.frame(scale(KEGGPathway,center = F),check.names = F) %>% select_if(~!any(is.na(.)))

# Generate annotations for rows and columns
annotation_col1=read.table("result\\eggnog-230618\\COG_category_anno_col.txt", header = TRUE, row.names = 1, sep = "\t")
annotation_row1=read.table("result\\eggnog-230618\\KEGG.Pathway_anno.row.txt", header = TRUE, row.names = 1, sep = "\t")
#生成图片
KEGGPathway_p <- pheatmap(KEGGPathway_S2,main = "KEGGPathway", annotation_col = annotation_col1,annotation_row = annotation_row1,show_rownames=TRUE,show_colnames=F,color = colorRampPalette(colors = c("white","red"))(100))

# 保存图片
ggsave(file = "E:\\Ja序列分析\\宏基因组\\课题--测序\\粪便-咽拭子样本\\06eggnog_mapper\\result\\eggnog-230618\\eggnog.KEGGPathwayL2.raw.pdf",plot = KEGGPathway_p, width = 30,height = 12, units = "in",limitsize = FALSE)











# CAZy by dbCAN2库
# 数据导入
CAZy=read.table("result\\dbcan2-230618\\TPM.CAZy.raw.txt", header = TRUE, row.names = 1, sep = "\t",check.names = FALSE)

#归一化并去除含有NA的列
CAZy_S2 <- data.frame(scale(CAZy,center = F),check.names = F) %>% select_if(~!any(is.na(.)))

# Generate annotations for rows and columns
annotation_col1=read.table("result\\dbcan2-230618\\COG_category_anno_col.txt", header = TRUE, row.names = 1, sep = "\t")
annotation_row1=read.table("result\\eggnog-230618\\CAZy_anno_row2.txt", header = TRUE, row.names = 1, sep = "\t")

#生成图片
CAZy_p <- pheatmap(CAZy_S2,main = "CAZy", annotation_col = annotation_col1,annotation_row = annotation_row1, show_rownames=TRUE,show_colnames=F,color = colorRampPalette(colors = c("white","red"))(100))

# 保存图片
ggsave(file = "E:\\Ja序列分析\\宏基因组\\课题--测序\\粪便-咽拭子样本\\06eggnog_mapper\\result\\dbcan2-230618\\CAZy.raw.pdf",plot = CAZy_p, width = 30,height = 15, units = "in",limitsize = FALSE)




















# Example
# Create test matrix
test = matrix(rnorm(200), 20, 10)
test[1:10, seq(1, 10, 2)] = test[1:10, seq(1, 10, 2)] + 3
test[11:20, seq(2, 10, 2)] = test[11:20, seq(2, 10, 2)] + 2
test[15:20, seq(2, 10, 2)] = test[15:20, seq(2, 10, 2)] + 4
colnames(test) = paste("Test", 1:10, sep = "")
rownames(test) = paste("Gene", 1:20, sep = "")

annotation_col = data.frame(
  CellType = factor(rep(c("CT1", "CT2"), 5)), 
  Time = 1:5
)
rownames(annotation_col) = paste("Test", 1:10, sep = "")

annotation_row = data.frame(
  GeneClass = factor(rep(c("Path1", "Path2", "Path3"), c(10, 4, 6)))
)
rownames(annotation_row) = paste("Gene", 1:20, sep = "")

pheatmap(test, annotation_col = annotation_col)
pheatmap(test, annotation_col = annotation_col, annotation_legend = FALSE)
pheatmap(test, annotation_col = annotation_col, annotation_row = annotation_row)

# Change angle of text in the columns
pheatmap(test, annotation_col = annotation_col, annotation_row = annotation_row, angle_col = "45")
pheatmap(test, annotation_col = annotation_col, angle_col = "0")

