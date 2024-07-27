from core.handlers.MessageHandler import MessageHandler


class MessageHandlerService:
    def __init__(self):
        self.handlers = {}

    def register_handler(self, key: str, handler: MessageHandler):
        self.handlers[key] = handler

    def get_handler(self, key: str) -> MessageHandler:
        return self.handlers.get(key, self.handlers.get("base_handler"))
