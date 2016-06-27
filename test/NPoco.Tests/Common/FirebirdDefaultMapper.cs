﻿using System;
using System.Reflection;
using NPoco;

namespace NPoco.Tests.Common
{
    internal class FirebirdDefaultMapper: DefaultMapper
    {
        private bool isNullable(Type type)
        {
            return (type.GetTypeInfo().IsGenericType && type.GetGenericTypeDefinition() == typeof (Nullable<>));
        }

        public override Func<object, object> GetFromDbConverter(Type DestType, Type SourceType)
        {
            // Db:String -> String
            if ((DestType == typeof(string)) && (SourceType == typeof(string)))
            {
                return src => (src as string)?.Trim();
            }

            // Db:String -> Guid
            if ((DestType == typeof (Guid)) && (SourceType == typeof (string)))
            {
                return src => Guid.Parse((string)src);
            }

            // Db:String -> Guid?
            if (isNullable(DestType))
            {
                var underlyingType = Nullable.GetUnderlyingType(DestType);
                if (underlyingType == typeof (Guid) )
                {
                    return src => (src == null ? (Guid?) null : Guid.Parse((string) src));
                }
            }

            return base.GetFromDbConverter(DestType, SourceType);
        }


        public override Func<object, object> GetToDbConverter(Type destType, MemberInfo sourceMemberInfo)
        {
            // Db:Guid -> string
            if ((destType == typeof(string)) && (sourceMemberInfo.GetTheType() == typeof(Guid)))
            {
                return src =>
                {
                    Guid guid = (Guid)src;
                    return (guid == Guid.Empty) ? null : guid.ToString();
                };
            }

            return base.GetToDbConverter(destType, sourceMemberInfo);
        }
    }
}
