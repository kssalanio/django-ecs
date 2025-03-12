from django.contrib import admin
from .models import Todo
    
class TodoAdmin(admin.ModelAdmin):
    list_display = ("completed", "title", "description", "date_created", "date_completed")
        
# Register your models here.
admin.site.register(Todo, TodoAdmin)