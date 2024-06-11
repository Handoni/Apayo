from typing import List, Optional
from pydantic import BaseModel


class HospitalQuery(BaseModel):
    xPos: float
    yPos: float
    department: str

class HospitalItem(BaseModel):
    YPos: Optional[str]
    XPos: Optional[str]
    yadmNm: Optional[str]
    telno: Optional[str]
    addr: Optional[str]

class HospitalResponseBody(BaseModel):
    items: List[HospitalItem]