import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
// import { ConfigService } from '@nestjs/config';

import { ExtractJwt, Strategy } from 'passport-jwt';

import { UsersService } from 'src/modules/users/users.service';
import { JwtPayload } from '../interfaces/jwt-payload.interface';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private readonly usersService: UsersService,
    // configService: ConfigService,
  ) {
    super({
      secretOrKey: 'secret', //  configService.get<string>('JWT_SECRET')
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    });
  }

  async validate(payload: JwtPayload) {
    const { email } = payload;
    const user = await this.usersService.findOneByEmail(email);

    if (!user.isVerified)
      throw new UnauthorizedException('El usuario no ha sido autenticado');

    // Lo que se retorna en la validacion, se añade a cualquier Request
    return user;
  }
}
