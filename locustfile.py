from locust import HttpUser, task

class GramadoirUser(HttpUser):
    @task
    def gramadoir(self):
        self.client.get("/gramadoir/mo%20madra")
