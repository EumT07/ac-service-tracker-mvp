from django.apps import AppConfig


class AcServiceTrackerConfig(AppConfig):
    name = 'ac_service_tracker'

    def ready(self):
        # Signal
        import ac_service_tracker.signals
