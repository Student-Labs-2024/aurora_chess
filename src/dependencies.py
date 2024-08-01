from core.factories.WebsocketPlayerSessionFactory import WebsocketPlayerSessionFactory
from core.handlers.ConnectionRequestHandler import ConnectionRequestHandler
from core.handlers.RoomInitRequestHandler import RoomInitRequestHandler
from core.repository.RoomRepository.RAMRoomRepository import RAMRoomRepository
from core.services.MessageHandlerService import MessageHandlerService
from core.services.RoomService import RoomService


message_dispatcher = MessageHandlerService()
rooms_service = RoomService(RAMRoomRepository())
player_session_factory = WebsocketPlayerSessionFactory()
message_dispatcher.register_handler("roomInitRequest", RoomInitRequestHandler(rooms_service,
                                                                              player_session_factory))
message_dispatcher.register_handler("roomConnectionRequest", ConnectionRequestHandler(rooms_service,
                                                                                      player_session_factory))
