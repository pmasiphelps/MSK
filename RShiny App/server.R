library(shiny)
library(datasets)
library(ggplot2)

# Define server logic required to draw a histogram
function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically
  #     re-executed when inputs change
  #  2) Its output type is a plot
  output$wordPlot = renderPlot({
    frequency <-t1_class %>%
      count(Class, word) %>%
      filter(n > 2e1) %>%
      group_by(Class) %>%
      mutate(freq = n / sum(n)) %>% 
      select(-n) %>% 
      spread(Class, freq) 
    
    
    frequency = frequency %>% gather(Class, freq, input$var2,input$var3)
    ggplot(frequency, aes(x = freq, y = frequency[input$var1])) +
      geom_abline(color = "gray40", lty = 2) +
      geom_jitter(alpha = 0.1, size = 2.5, width = 0.1, height = 0.1) +
      geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
      scale_x_log10(labels = percent_format()) +
      scale_y_log10(labels = percent_format()) +
      #scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray95") +
      facet_wrap(~Class, ncol = 2) +
      theme(legend.position="none") +
      labs(y = "Class", x = NULL)
  
  ggplot(frequency, aes(x = freq, y = frequency[input$var1])) +
    geom_abline(color = "gray40", lty = 2) +
    geom_jitter(alpha = 0.1, size = 2.5, width = 0.1, height = 0.1) +
    geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
    scale_x_log10(labels = percent_format()) +
    scale_y_log10(labels = percent_format()) +
    #scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray95") +
    facet_wrap(~Class, ncol = 2) +
    theme(legend.position="none") +
    labs(y = input$var1, x = NULL)
  })
  output$barPlot = renderPlot({
    ggplot(data=barplot_data, aes(x=reorder(Class, -Counts), y=Counts)) +
      geom_bar(stat="identity", width=0.5, color = "purple", fill="steelblue") + 
      geom_text(aes(label=Counts), vjust=-0.3, size=3.5) + theme_minimal() + 
      labs(x="Classes",y="Number of Entries by Class") + ggtitle('Number of Data Entries for Each Class')+
      theme(plot.title = element_text(hjust = .5))
  })
  output$histPlot = renderPlot({
  hist(hydro, xlab="Absolute value of electric/hydrophobic difference", main= "Distribution of Mutations across Electric/Hydrophobic Spectrum", 
       breaks = input$bins, xlim=c(0,10),col='skyblue',border=F, bins = input$bins)
  hist(elec, breaks = input$bins, add=T,col=scales::alpha('red',.5),border=F, bins = input$bins)
  })
  
  output$mut_barPlot = renderPlot({
    ggplot(data=top12_mutations, aes(x=reorder(Variation, -Counts), y=Counts)) +
      geom_bar(stat="identity", width=0.5, color = "purple", fill="steelblue") + 
      geom_text(aes(label=Counts), vjust=-0.3, size=3.5) + theme_minimal() + 
      labs(x="Mutation Type",y="Number of Occurrences") + ggtitle('Top 12 Mutation Types by Frequency') +
      theme(plot.title = element_text(hjust = .5)) + theme(axis.text.x = element_text(angle = 25, hjust = 1))
  })
  output$freq_words = renderPlot({
    tf_idf %>%
      arrange(desc(tf_idf)) %>%
      mutate(word = factor(word, levels = rev(unique(word)))) %>%
      group_by(Class) %>%
      top_n(10, tf_idf) %>%
      ungroup() %>%  
      ggplot(aes(word, tf_idf, fill = Class)) +
      geom_col() +
      labs(x = NULL, y = "tf-idf") +
      theme(legend.position = "none") +
      facet_wrap(~ Class, ncol = 3, scales = "free") +
      coord_flip() + ggtitle('Top Words by Class')
  })
  
  output$topGenes = renderPlot({
    top_gene %>%
      ggplot(aes(reorder(Gene, ct, FUN = min), ct)) +
      geom_point(size = 3, color = 'steelblue') +
      labs(x = "Gene", y = "Frequency") +
      coord_flip() + ggtitle('Most Common Genes in Training Data') + 
      theme(plot.title = element_text(hjust = .5)) 
  })
  output$topGenes_test = renderPlot({
    top_test_gene %>%
      ggplot(aes(reorder(Gene, ct, FUN = min), ct)) +
      geom_point(size = 3, color = 'steelblue') +
      labs(x = "Gene", y = "Frequency") +
      coord_flip() + ggtitle('Most Common Genes in Test Data') + 
      theme(plot.title = element_text(hjust = .5))
  })
  output$table <- renderDataTable(train_extra)
  
 
}
