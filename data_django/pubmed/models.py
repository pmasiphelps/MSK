from django.db import models

# Create your models here.

class Abstract(models.Model):
	pmid = models.CharField(max_length=50)
	title = models.CharField(max_length=500)
	author = models.CharField(max_length=250)
	journal = models.CharField(max_length=250)
	abstract = models.CharField(max_length=1000, null=True, blank=True)

	def __str__(self):
		return self.pmid + ': ' + self.title

class Article(models.Model):
	pmid = models.CharField(max_length=50)
	text = models.CharField(max_length=1000)
	classification = models.CharField(max_length=100,null=True, blank=True)

	def __str__(self):
		return self.pmid + ': ' + self.gene + '-' + self.variation

class Gene(models.Model):
	gene_symbol = models.CharField(max_length=50)
	gene_abb = models.CharField(max_length=100)
	location = models.CharField(max_length=250)
	description = models.CharField(max_length=1000)

	def __str__(self):
		return self.gene_symbol + ': ' + self.description

class Variation(models.Model):
	mutation = models.CharField(max_length=100)
	pathway = models.CharField(max_length=250)

		
		

	