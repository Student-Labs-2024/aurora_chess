from core.entities.AbstractGameRoom import AbstractGameRoom


class AbstractGameRoomFactory:
    def create_room(self, *args) -> AbstractGameRoom:
        pass
