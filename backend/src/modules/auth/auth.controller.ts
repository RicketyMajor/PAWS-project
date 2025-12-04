import {
  Body,
  Controller,
  Patch,
  Post,
  //UseGuards,
  Request,
  //Get,
} from '@nestjs/common';

import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { UpdateDto } from './dto/update.dto';
//import { AuthGuard } from '@nestjs/passport';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  register(@Body() registerDto: RegisterDto) {
    return this.authService.register(registerDto);
  }

  @Post('login')
  login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @Patch('update-with-email')
  update(@Request() req, @Body() updateDto: UpdateDto) {
    console.log(req.user.email);
    return this.authService.updateEmail(req.user.email, updateDto);
  }

  @Patch('update-with-id')
  updateWithId(@Request() req, @Body() updateDto: UpdateDto) {
    console.log(req.user.id);
    return this.authService.updateWithId(req.user.id, updateDto);
  }

  @Post('verify')
  verify(@Body('email') email, @Body('verification_code') verification_code) {
    return this.authService.verifyCode(email, verification_code);
  }

  @Post('send-register-code')
  sendRegisterCode(@Body('email') email) {
    return this.authService.sendRegisterCode(email);
  }
}
