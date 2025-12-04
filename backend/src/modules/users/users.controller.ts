import {
  Controller,
  Get,
  Body,
  Patch,
  Param,
  Delete,
  // UseGuards,
  Request,
  NotFoundException,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('profile')
  async profile(@Request() req) {
    const user = await this.usersService.findOneById(req.user.id);
    if (!user) {
      return new NotFoundException('Usuario no encontrado');
    }
    return this.usersService.findOneById(req.user.id);
  }

  @Delete('delete-account')
  delete(@Request() req) {
    return this.usersService.remove(req.user.id);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.usersService.findOneById(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.usersService.update(id, updateUserDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.usersService.remove(+id);
  }
}
