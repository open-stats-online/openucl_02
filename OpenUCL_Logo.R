# libraries needed
library(ggplot2)
library(grid)

# random seed value fixed to 1234
set.seed(1234)

#make a normal dataset
value=rnorm(5400,10)
data = data.frame(value)

# or this does both steps above in one
# data=data.frame(value=rnorm(5400,10))

# Build histogram p
p = ggplot(data, aes(x=value)) + 
    geom_histogram(binwidth=.6,
                 fill="#69b3a2",
                 color = "#e9ecef") +
    xlim(6, 11) +         
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.ticks.x  = element_blank(),
          axis.ticks.y  = element_blank(),
          axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          panel.border = element_rect(colour = "black", fill=NA, size=1))


grob1 <- grobTree(textGrob("Open", x=0.04,  y=0.87, hjust=0,
                          gp=gpar(col="black", fontsize=50, fontface ="bold")))
grob2 <- grobTree(textGrob("UCL", x=0.04,  y=0.65, hjust=0,
                           gp=gpar(col="black",  fontsize=50, fontface = "bold")))


# Plot
p + annotation_custom(grob1) + annotation_custom(grob2)


