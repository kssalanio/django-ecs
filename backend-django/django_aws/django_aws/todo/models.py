from django.db import models
from django.utils import timezone

# Todo task model
class Todo(models.Model):
    title = models.CharField(max_length=120)
    description = models.TextField()
    completed = models.BooleanField(default=False)
    date_created = models.DateTimeField(default=timezone.now)
    date_completed = models.DateTimeField(default=timezone.now)
        
    def __str__(self):
        return self.title