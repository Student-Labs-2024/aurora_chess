from core.schemas.mixins.error_mixin import ErrorsMixin
from core.schemas.mixins.json_type_str_mixin import JsonTypeStrMixin
from core.schemas.mixins.system_message_mixin import SystemMessagesMixin


class UnknownMessageResponse(JsonTypeStrMixin, SystemMessagesMixin, ErrorsMixin):
    data: None = None
